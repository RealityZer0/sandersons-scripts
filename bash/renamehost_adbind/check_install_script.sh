#!/bin/sh

# Check domain connection
AD_HOST="$(/usr/bin/host domain.com |awk 'FNR == 1 {print $1}')"
# Checks AD bind status
AD_INFO="$(dsconfigad -show | grep "Active Directory Domain" | sed -e 's/.*=\ //')"
# Confirms AD bind status
AD_COMP="$(dscl localhost -read "/Active Directory/DOMAIN"|grep "AccountName:"|awk '{print $2}')"
AD_CONF="$(dscl "/Active Directory/DOMAIN/All Domains" -read /Computers/$AD_COMP | awk '/RealName/ {print $2}')"


##########################################
# Checks that the domain host is available
if [ $AD_HOST == "domain.com" ]; then
	echo "CORP network present"
else
	echo "Not on CORP network"
	exit 1
fi

# Checks that dsconfigad shows domain.com
if [ -z $AD_INFO ]; then
		echo  "DSConfigAD shows not bound to AD"
	else
		echo "DSConfigAD shows bound to AD"
fi

# Checks
if [ -z $AD_CONF ]; then
		echo  "Directory Services error, dscl Active Directory query failed"
	else
		echo "DSCL Active Directory query check successful"
fi


exit 0
