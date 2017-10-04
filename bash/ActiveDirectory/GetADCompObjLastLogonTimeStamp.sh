#!/bin/bash

ADCOMP="$(dsconfigad -show | awk '/Computer Account/ {print $4}')"
domain="domain"
LastLogin="$(dscl "/Active Directory/${domain}/${domain}" -read /Computers/$ADCOMP "lastLogonTimestamp"|awk '{print $2}')"

LLTS=$((LastLogin/10000000-11644473600))
echo $LLTS
LLTSHR=$(date -j -f %s $LLTS)
exit 0
