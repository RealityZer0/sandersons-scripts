#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: AppRequestAuto
# SYNOPSIS: Automated App requests install_check_script
# APP REQUESTED: 
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
appRequest="AppRequested"
# App AD Group
appADGroup="/Groups/MacLicense-MacADGroup"
# App request failed
appFail="$userPath/$appRequest-no-connection.txt"
#
domain="domain.com"
#==========#
# COMMANDS
#==========#
if ping -c 2 -o "${domain}"; then
	dscl "/Active Directory/${domain}/All Domains" read "$appADGroup" GroupMembership |grep -o "$ADComp"
	if [[ $? == 0 ]]; then
		echo "$ADComp is already a member of $appADGroup"
	else
		echo "$ADComp is not a member of $appADGroup. Submitting request."
		exit 0
	fi
else
	echo "$ADComp is not on the "${domain}", cannot process request." > "$appFail"
fi

exit 1
