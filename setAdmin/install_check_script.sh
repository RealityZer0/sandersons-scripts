#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: SetLocalAdminRights
# SYNOPSIS: This will run as a munki install_check script
# exit status of 0 equals install
# exit status 1 equals no install
#==========#
# HISTORY:
# Version 1.3
# Created by Scott Anderson on 04/11/17
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
domain="domain"
svcAccount="svc_macosx_adbind"
macOSAdmin="OSX_Local_Admins"
userName="$(ls -la /dev/console | awk '{print $3}')"
domainAns="$(dscl "/Active Directory/${domain}/All Domains" -read /Users/${userName} sAMAccountName | awk '{print $2}')"
domainID="$(/usr/bin/id -G $userName | grep -c 40000)"
# Check user is member of Active Directory
queryAD="$(/usr/sbin/dseditgroup -o checkmember -n "/Active Directory/domain/All Domains" -m $userName -read "$macOSAdmin" |awk 'FNR == 1 {print $1}')"

# Check if root or macadmin is console user
if [[ -z "$userName" || "$domainID" -eq 0 ]]; then
  echo "Exiting script, invalid user." &>/dev/null
  exit 1
fi

if ping -o "domain.yp.com"; then
	if [[ "$domainAns" =~ "is not valid" ]]; then
		echo "Not bound to $domain domain."&>/dev/null
		exit 1
	else
		if [ "$queryAD" = "yes" ]; then
			echo "$userName is a member of OSX_Local_Admins, checking local admin status."
		  exit 0
    else
      echo "$userName is NOT a member of OSX_Local_Admins."
      exit 1
		fi
	fi
else
	echo "No connection to $domain. Connect $HOSTNAME to YP LAN, YP WLAN or VPN and try again."
fi

exit 1
