#!/bin/bash
userName=`ls -la /dev/console | awk '{print $3}'`
domain="domain.com"
checkHost=`/usr/bin/host ${domain} |awk 'FNR == 1 {print $1}'`
gID="12345"
corpID=`/usr/bin/id -G ${userName} | grep -c ${gID}`# insert groupID assigned for AD
adGroup="admacOSGroup"

if [[ ${corpID} -eq 0 ]]; then
	exit 1
fi
#Checks that the domain host is available
if [[ ${checkHost} = "corp.yp.com" ]]; then
	echo "DC Present"
else exit 1
fi
#Checks AD bind status or use | awk '{print $5}'
isBoundtoAD=`dsconfigad -show | grep "${domain}" | sed -e 's/.*=\ //'`
if [[ ${isBoundtoAD} = "${domain}" ]];then
		echo "Bound to AD"
	else
		exit 1
fi
#Queries an AD group to verify connection to AD
queryAD=`dseditgroup -o checkmember -n "/Active Directory/${domain}/All Domains" -m ${userName} -read "${adGroup}"|awk 'FNR == 1 {print $1}'`
if [[ "${queryAD}" != "yes" ]]; then
	/usr/sbin/dseditgroup -o edit -n /Local/Default -d "${userName}" -t user admin
else echo "AD query failed"
fi

exit 1
