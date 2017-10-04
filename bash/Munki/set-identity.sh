#!/bin/bash
#==========#
# ABOUT THIS SCRIPT:
# NAME: Munki Client Certs
# SYNOPSIS: Get hostname FQDN and set identity preference for https://munki.domain.com .
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson on 10/26/2016
# Revision Date
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
TARGET_VOL="$3"
domain="domain"
currentUser="$(ls -la /dev/console | awk '{print $3}')"
hostFQDN="$(dscl "/Active Directory/${domain}/All Domains" read /Computers/$HOSTNAME$ DNSName | awk '{print $2}')"

#Set identity preference for MunkiRepo URL
security set-identity-preference -s http://munki.domain.com/ -c $hostFQDN /Library/Keychains/System.keychain


exit 0
