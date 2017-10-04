#!/bin/sh
# Domain name here (may need to use short/netbios name)
domain="domain.com"
# Check domain connection
CHECKDOMAIN="$(/usr/bin/host ${domain} |awk 'FNR == 1 {print $1}')"
#Check Active Directory LDAP connection
ADNODE="$(/usr/bin/odutil show nodenames | grep ${domain} | grep -v Virtual | awk '{print $3}')"
# Checks AD bind status
ADINFO="$(dsconfigad -show | grep "Active Directory Domain" | sed -e 's/.*=\ //')"
# Confirms AD bind status
ADCONF="$(dscl localhost -read "/Active Directory/${domain}"|grep "AccountName:"|awk '{print $2}')"
##########################################
# Checks that the domain host is available
if [ $CHECKDOMAIN = "${domain}" ]; then
	echo "${domain} network present"
else
	echo "Not on ${domain} network!"
	exit 1
fi

# Checks that dsconfigad shows domain.com
if [ -z ${ADINFO} ]; then
		echo  "Not bound to AD"
	else
		echo "Bound to AD"
		exit 1
fi

# Checks
if [ -z ${ADCONF} ]; then
		echo  "Directory Services error, not Bound to AD"
		exit 1
	else
		echo "AD bind check successful"

fi


exit 0
