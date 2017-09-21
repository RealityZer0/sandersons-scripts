#!/bin/sh

# Check domain connection
CHECKDOMAIN="$(/usr/bin/host corp.yp.com |awk 'FNR == 1 {print $1}')"
# Checks AD bind status
ISBOUNDTOAD="$(dsconfigad -show | grep "Active Directory Domain" | sed -e 's/.*=\ //')"
# Check VPN connection (VPN doesn't allow efective communications with AD)
VPNCONN="$(ifconfig utun0|grep -c 10)"
#Check Active Directory LDAP connection
ADLDAP="$(/usr/bin/odutil show nodenames | grep CORP | grep -v Virtual | awk '{print $3}')"

# Checks that the domain host is available
if [ $CHECKDOMAIN == "corp.yp.com" ]; then
	echo "Domain Present"
else 
	exit 1
fi

# Checks that the host is bound to AD
if [ $ISBOUNDTOAD == "corp.yp.com" ]; then
		echo "Bound to AD"		
	else 
		exit 1
fi

# Checks VPN connection
if [ $VPNCONN -eq 1 ]; then
	echo "Terminating due to VPN connection"
	exit 1
fi

# Checks AD LDAP connection
if [ $ADLDAP == "Offline" ]; then
	exit 1
fi

exit 0