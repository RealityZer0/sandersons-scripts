#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: AppRequestAuto
# SYNOPSIS: Automated App requests install_check_script
# APP REQUESTED: MacroMates TextMate 2
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson
# Creation Date 10/18/16
#==========#
# ADDITIONAL INFO:
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
# Get current AD computer object name sans $
ADComp="$(dsconfigad -show | awk '/Computer Account/ {print $4}'| tr -d \$)"
# Get console user
userName="$(ls -la /dev/console | awk '{print $3}')"
# Set current user path
userPath="/Users/$userName/Desktop"
# App Requested
appRequest="TextMate2"
# App AD Group
appADGroup="Mac-TextMate2"
# App request failed
appFail="$userPath/$appRequest-not_installed.txt"
# Check if computer is already in app AD Group
appCheck="$(dscl "/Active Directory/DOMAIN/All Domains" read /Groups/"$appADGroup" GroupMembership |grep -o "$ADComp")"
#==========#
# COMMANDS
#==========#
#if ping -c 2 -o "domain.com"; then
	#dscl "/Active Directory/DOMAIN/All Domains" read "/Groups/$appADGroup" GroupMembership |grep -o "$ADComp"
	if [[ "$appCheck" == "$ADComp" ]]; then
		echo "Request denied, the computer $ADComp is already a member of the requested Active Directory group, $appADGroup." > "$appFail"
		exit 1
	else
		echo "$ADComp is not a member of $appADGroup. Submitting request."
		exit 0
	fi
	#else
	#echo "The app request for $appRequest failed because $ADComp is not on the corporate network. Please connect via DOMAIN wifi, LAN or VPN and try again." > "$appFail"
	#fi

exit 1
