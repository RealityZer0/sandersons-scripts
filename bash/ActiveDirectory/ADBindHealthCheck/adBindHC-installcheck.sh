#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: ADBindHealthCheck
# SYNOPSIS: This will run as a munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson on 4/20/16
# Revision Date
#==========#
# ADDITIONAL INFO:
# Parts of this were borrowed from Aziz
# https://jamfnation.jamfsoftware.com/discussion.html?id=14864#responseChild91124
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
domain="domain"
user="svc_macosx_adbind"
domainAns="$(dscl "/Active Directory/${domain}/All Domains" -read /Users/${user} dsAttrTypeNative:userPrincipalName)"
if ping -c 2 -o "domain.com"; then
	if [[ $domainAns =~ "is not valid" ]]; then
    	result="Valid"
		echo "$result"
		exit 0
	else
    	result="Invalid"
		echo "$result"
	fi
else
	echo "No connection to $domain. Connect $HOSTNAME to DOMAIN LAN, WLAN or VPN and try again."
fi

exit 1
