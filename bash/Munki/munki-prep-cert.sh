#!/bin/bash
#==========#
# ABOUT THIS SCRIPT:
# NAME: Munki Client Certs
# SYNOPSIS: This will dump and extract the relevant keychain identities for Munki SSL authentitcation.
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson on 8/30/2016
# Revision Date
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
destpath="/Library/Managed Installs/certs"
destfile="${destpath}/munki.pem"
userName="$(ls -la /dev/console | awk '{print $3}')"
currentUserUID=$(id -u "${userName}")
userPid="$(ps -ef |grep loginwindow|grep -v "grep"|awk '{print $2}')"

#Check for munki certs first!
#if [ ! -e "$destfile" ]; then
#	echo "Munki cert not available, proceed"
#else
#	echo "Munki certs exist, exiting"
#	exit 1
#fi

#Export all System keychain identies (cert/key pairs) to /tmp/munkitemp.p12
security export -t identities -o /tmp/munkitemp.p12 -k /Library/Keychains/System.keychain -f pkcs12 -P temppass

#Convert pkcs12 identities to PEM with unencrypted keys
openssl pkcs12 -in /tmp/munkitemp.p12 -out /tmp/munkitemp.pem -passin pass:temppass -nodes

#Extract the cert

cert=$(openssl crl2pkcs7 -nocrl -certfile /tmp/munkitemp.pem | openssl pkcs7 -print_certs | awk "/issuer.*DC=com\/DC=domain\/CN=PKI-SRVR-HERE/,/END CERTIFICATE/")

#Extract the key
key=$(awk '/PKI-SRVR-HERE.domain.com/,/END RSA PRIVATE KEY/' /tmp/munkitemp.pem)

#Write combined cert/key pair
identity="${cert}"$'\n'"${key}"
mkdir "$destpath"
echo "$identity" > "$destfile"
chmod 700 "$destpath"
chmod 600 "$destfile"

rm -rf /tmp/munkitemp.*
exit 0
