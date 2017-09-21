#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: AppRequestAuto
# SYNOPSIS: Automate App requests via munki and SCOrch
# APP REQUESTED: MacroMates TextMate 2
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson
# Creation Date 7/21/16
#==========#
# ADDITIONAL INFO:
#==========#
# PATH
#==========#
#PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/#sbin:/usr/local/munki
#export PATH
#==========#
# VARIABLES
#==========#
# Get console user
userName="$(ls -la /dev/console | awk '{print $3}')"
# Remote smb connection
smbConn="corp/ypzone/Software/Orchestrator-Mac"
# Remote smb path
smbPath="smb://path/to/share/"
#Clean hostname
ADComp="$(dsconfigad -show | awk '/Computer Account/ {print $4}'| tr '[:lower:]' '[:upper:]' | tr -d \$)"
# App Requested
appRequest="TextMate2"
# Path to file
appReqPath="/Volumes/share"
#appReqPath="/Users/$userName/mnt/.Orchestrator-Mac"
# App Request Filename
appReqTxt="MacRequest.txt"
# App request failed
appFail="$userPath/$appRequest-failed.txt"
# App request succeeded
appSuccess="$userPath/$appRequest-succeeded.txt"
# App AD Group
appADGroup="MacLicense-AppName"
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# COMMANDS
#==========#
if [[ ! -d "$appReqPath" ]]; then
	#sudo -u "$userName" mkdir -p "$appReqPath"
	sudo -u "$userName" open -a "Finder" "$smbPath"
	wait
	#touch "$appReqPath"/"$appReqTxt"
#else
	#sudo -u "$userName" open -a "Finder" "$smbPath"
	#touch "$appReqPath"/"$appReqTxt"
	#sleep 10
fi

#==========#
# FUNCTIONS
#==========#
# Display success dialog
success () {
  osascript <<EOT
    tell app "System Events"
      display dialog "$1" buttons {"OK"} default button 1 with icon note with title "Success"
      return  -- Suppress result
    end tell
EOT
}

# Display warning dialog
warning () {
  osascript <<EOT
    tell app "System Events"
      display dialog "$1" buttons {"OK"} default button 1 with icon note with title "Warning"
      return  -- Suppress result
    end tell
EOT
}

# Display prompt to request
prompt () {
  osascript <<EOT
    tell app "System Events"
      text returned of (display dialog "$1" default answer "$2" buttons {"OK"} default button 1 with title "Reason for Request")
    end tell
EOT
}

requestReason="$(prompt 'Please provide a reason for the software request:' '')"
#echo "Attempting to write to file"
if [[ "$requestReason" = "" ]]; then
	warning "Please provide a business justification"
	requestReason="$(prompt 'Please provide a reason for the software request:' '')"
fi
touch "$appReqPath"/MacRequest.txt
echo "$userName" "\\" "$ADComp" "\\" "$appRequest" "\\" "$appADGroup" "\\" "$requestReason" >> "$appReqPath"/MacRequest.txt

sleep 5
diskutil unmount force "$appReqPath"
if [[ -e "$appReqPath/$appReqTxt" ]]; then
	warning "Application request failed. Please try again."
else
	success "The app request for $appRequest succeeded. Please look for an email containing the  IT ticket number"
fi
exit 0
