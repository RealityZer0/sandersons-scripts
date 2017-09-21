#!/bin/bash
#############################################################
# Purpose: To report on the status of iCloud Preferences
# Author: GaToRAiD (Andrew Barrett)
# Date: 11/3/14
# Version: 2.0
#############################################################

for ((i=0; i<12; i++));
do
Service="$(defaults read /Users/sa8678/Library/Preferences/MobileMeAccounts.plist)"
serviceName="$(echo "$Service" | egrep "Name" | awk -F' ' '{print $3}')"
serviceStatus="$(echo "$Service" | egrep "Enabled" | awk -F' ' '{print $3}')"
if [[ -z "$serviceStatus" ]]; then
serviceStatus="$(echo "$Service" | egrep "beta" | awk -F' ' '{print $3}')"
fi
serviceInfo="${serviceInfo}\n Service Name: $serviceName\n Service Status: $serviceStatus"

done

echo -e "<result>$serviceInfo</result>"

#############################################################
