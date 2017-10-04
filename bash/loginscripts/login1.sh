#!/bin/bash
version="1.0"
#Check logged in console user
userName="$(ls -la /dev/console | awk '{print $3}')"
enableFV="/usr/local/scripts/enablefv.sh"
sysAdmPref="/usr/local/scripts/en-sysprefadm.sh"
################################################################################
# Exit if Mac is in MCX Debug mode
if [ -e "/Library/.mcx_debug" ]; then
	exit 1
fi
################################################################################
# Ensure network time is "ON"
/usr/sbin/systemsetup -setusingnetworktime on &
################################################################################
# Store Properties of most recent logon
# Login script version
/bin/echo $version >/Library/Preferences/.login_script_version &
################################################################################
# Current user's shortname
/bin/echo $userName >/Library/Preferences/.currentuser
################################################################################
# Current user's home directory
userhome="$(/usr/bin/dscl . read /users/$userName home | awk '{print $2}')"
/bin/echo $userhome >/Library/Preferences/.currenthome
################################################################################
# Date & Time of login
/bin/date "+%b %d %H:%M:%S" >/Library/Preferences/.lastlogintime
################################################################################
# Exit prior to Crypt running if login user is not root or admin
if [[ $1 = "root" || $1 = "admin" ]]; then
  log "Exiting script for $1 logging in."
  exit 1
fi
################################################################################
#Enable FileVault2
if [ -e ${enableFV} ]; then
	${enableFV}
fi
################################################################################
#Enable System Preferences Admin Rights
if [ -e ${sysAdmPref} ]; then
	${sysAdmPref}
fi
################################################################################
# Add user to Line Print Admin group if they are not
#Quicker and easier way to add everyone to Printer Admins
/usr/sbin/dseditgroup -o edit -n /Local/Default -a everyone -t group _lpadmin
/usr/sbin/dseditgroup -o edit -n /Local/Default -a everyone -t group _lpoperator
################################################################################

exit 0
