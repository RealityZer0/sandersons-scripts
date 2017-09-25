#!/bin/bash
userName="(ls -la /dev/console | awk '{print $3}')"
domain="domain.com"
checkHost="(/usr/bin/host ${domain} |awk 'FNR == 1 {print $1}')"
gID="12345"
domainID="(/usr/bin/id -G $userName | grep -c ${gID})"
adGroup="adGroupHere"

if [[ $domainID -eq 0 ]]; then
	exit 1
fi
#Checks that the domain host is available
if [[ $checkHost = "${domain}" ]]; then
	echo "DC Present"
else
	exit 1
fi
#Checks AD bind status
isBoundtoAD="(dsconfigad -show | grep "Active Directory Domain" | sed -e 's/.*=\ //')"
if [[ $isBoundtoAD = "${domain}" ]];then
		echo "Bound to AD"
	else
		exit 1
fi
#Queries an AD group to verify connection to AD
queryAD="(dseditgroup -o checkmember -n "/Active Directory/DOMAIN/All Domains" -m $userName -read "${adGroup}"|awk 'FNR == 1 {print $1}')"
if [[ "$queryAD" != "yes" ]]; then
	/usr/sbin/dseditgroup -o edit -n /Local/Default -d "$userName" -t user admin
else
	echo "Admin rights not changed"
fi

exit 1
