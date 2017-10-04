#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: Domain Computer Profile
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
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
domain="domain.com"
userName="$(ls -la /dev/console | awk '{print $3}')"
adSvc="svc_account_here"
domainAns="$(dscl "/Active Directory/${domain}/All Domains" -read /Users/${adsvc} dsAttrTypeNative:userPrincipalName)"
profileCheck="$(profiles -Cv | grep "name: DOMAIN Computer Certificate" -4 | awk -F": " '/attribute: profileIdentifier/{print $NF}')"

# Exit on macadmin or root
if [[ -z $userName || $userName = "root" || $userName = "mac-admin" ]]; then
	echo "Exiting for $userName logging in."
	exit 1
fi

if ping -c 2 -o "${domain}"; then
	if [[ $domainAns =~ "is not valid" ]]; then
		echo "Not connected to AD, exiting."
		exit 1
	else
		echo "Connected to AD, checking for profile."
		if [[ -z $profileCheck ]]; then
			echo "Installing profile."
			exit 0
		else
			echo "Profile installed"
			exit 1
		fi
	fi
else
	echo "No connection to "$domain". Connect $HOSTNAME to company LAN, YP WLAN or VPN and try again."
fi

exit 1
