#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: CheckLocalAdminRights
# SYNOPSIS: This will run as a munki install_check script
# exit status of 0 equals install
# exit status 1 equals no install
#==========#
# HISTORY:
# Version 1.3
# Created by Scott Anderson on 11/09/16
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
adUser="svc_account"
domainAns="$(dscl "/Active Directory/${domain}/All Domains" -read /Users/${user} dsAttrTypeNative:userPrincipalName)"
gID="12345"
adminGroup="macos_admins"
userName="$(ls -la /dev/console | awk '{print $3}')"
domainID="$(/usr/bin/id -G ${userName} | grep -c ${gID})"
userGrpMem="$(/usr/bin/dscl . -read /groups/admin GroupMembership | grep -oiw ${userName} | wc -w | awk '{print $1}')"



# Check if root or macadmin is console user
if [[ -z "${userName}" || "${domainID}" -eq 0 ]]; then
  echo "Exiting script, invalid user." &>/dev/null
  exit 1
fi

if ping -c 2 -o "${domain}"; then
	if [[ ${domainAns} =~ "is not valid" ]]; then
		echo "Not bound to ${domain}"&>/dev/null
		exit 1
	else
		echo "Bound to ${domain}" &>/dev/null
    # Check user is member of Active Directory
  	queryAD="$(/usr/sbin/dseditgroup -o checkmember -n "/Active Directory/${domain}/All Domains" -m ${userName} -read "${adUser}"|awk 'FNR == 1 {print $1}')"
  	if [ "${queryAD}" = "yes" ]; then
  	echo "${userName} is a member of "${adminGroup}"."
		exit 0
    fi
	fi
else
	echo "No connection to ${domain}. Connect ${HOSTNAME} to ${domain} LAN, WLAN or VPN and try again."
fi

exit 1
