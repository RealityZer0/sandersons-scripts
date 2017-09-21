#!/bin/bash

ADCOMP="$(dsconfigad -show | awk '/Computer Account/ {print $4}')"
LastLogin="$(dscl "/Active Directory/CORP/corp.yp.com" -read /Computers/$ADCOMP "lastLogonTimestamp"|awk '{print $2}')"

LLTS=$((LastLogin/10000000-11644473600))
echo $LLTS
LLTSHR=$(date -j -f %s $LLTS)
exit 0