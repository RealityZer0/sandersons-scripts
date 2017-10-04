#!/bin/bash
# User running script; must be root.
SCRIPTUSER=$(whoami)
# Currently logged in user.
userName=$(/usr/bin/stat -f%Su /dev/console)
# Location and name of plist with recovery info. .plist file extension omitted.
PLISTFILE="/var/root/restart.plist"

## Get the OS version
OS="$(/usr/bin/sw_vers -productVersion | awk -F. '{print $2}')"

## This first user check sees if the logged in account is already authorized with FileVault 2
userCheck="$(fdesetup list | awk -v usrN="$userName" -F, 'index($0, usrN) {print $1}')"
if [ "${userCheck}" != "${userName}" ]; then
    echo "This user is not a FileVault 2 enabled user."
    exit 3
fi

## Check to see if the encryption process is complete
encryptCheck="$(fdesetup status)"
statusCheck=$(echo "${encryptCheck}" | grep "FileVault is On.")
expectedStatus="FileVault is On."
if [ "${statusCheck}" != "${expectedStatus}" ]; then
    echo "The encryption process has not completed."
    echo "${encryptCheck}"
    exit 4
fi

## Get the logged in user's password via a prompt
echo "Prompting ${userName} for their login password."

cat <<'SCRIPT' > "${TMPDIR}"authFilevault.scpt
set currentUser to do shell script "/usr/bin/stat -f%Su /dev/console"

tell application "System Events" to set fvAuth to text returned of (display dialog "Please enter login password for " & currentUser & ":" default answer "" with title "Login Password" buttons {"OK", "Cancel"} default button 1 with text and hidden answer)

return fvAuth
SCRIPT

userPass=$(osascript "${TMPDIR}"authFilevault.scpt)



if [[ ! "$userPass" ]]; then
    echo "User cancelled or blank password."
    exit 1
else
    /usr/bin/defaults write "${PLISTFILE}" RecoveryKey -string "$userPass"
fi

/usr/bin/defaults write /Library/Preferences/ManagedInstalls.plist PerformAuthRestarts -bool true
/usr/bin/defaults write /Library/Preferences/ManagedInstalls.plist RecoveryKeyFile "/var/root/restart.plist"

echo "Beginning Authorized restart"

#if [[ $OS -ge 9  ]]; then
    ## This "expect" block will populate answers for the fdesetup prompts that normally occur while hiding them from output
#    expect -c "
#    log_user 0
#    spawn fdesetup authrestart
#    expect \"Enter a password for '/', or the recovery key:\"
#    send "{${userPass}}"
#    send \r
#    log_user 1
#    expect eof
#    " | sed 1d > "${PLISTFILE}".plist
#else
#    echo "OS version not 10.9+ or OS version unrecognized"
#    echo "$(/usr/bin/sw_vers -productVersion)"
#    exit 5
#fi

exit 0
