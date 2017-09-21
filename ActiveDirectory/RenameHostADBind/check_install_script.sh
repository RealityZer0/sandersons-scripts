#!/bin/sh

# Check domain connection
domain="domain.com"
adHost="$(/usr/bin/host ${domain} |awk 'FNR == 1 {print $1}')"
# Checks AD bind status
adInfo="$(dsconfigad -show | grep "Active Directory Domain" | sed -e 's/.*=\ //')"
# Confirms AD bind status
adComp="$(dscl localhost -read "/Active Directory/${domain}"|grep "AccountName:"|awk '{print $2}')"
adConf="$(dscl "/Active Directory/${domain}/All Domains" -read /Computers/${adComp} | awk '/RealName/ {print $2}')"


##########################################
# Checks that the domain host is available
if [[ ${adHost} = "${domain}" ]]; then
	echo "${domain} network present"
else
	echo "Not on ${domain} network"
	exit 1
fi

# Checks that dsconfigad shows corp.yp.com
if [[ -z ${adInfo} ]]; then
		echo  "DSConfigAD shows not bound to AD"
	else
		echo "DSConfigAD shows bound to AD"
fi

# Checks
if [[ -z ${adConf} ]]; then
		echo  "Directory Services error, dscl Active Directory query failed"
	else
		echo "DSCL Active Directory query check successful"
fi


exit 0
