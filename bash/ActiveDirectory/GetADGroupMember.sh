#!/bin/bash

# Get console user
userName="$(ls -la /dev/console | awk '{print $3}')"
# Set current user path
userPath="/Users/$userName/Desktop"
# Today's date
NOW=$(date "+%m%d%Y")
# Today's time
NOWT=$(date "+%H%M%S")
# Active Directory Domain
ADDomain="domain.com"
# Active Directory Group
ADGroup="adGroupHere"
# Active Directory Group Member
ADGroupMembers="$(dscl "/Active Directory/$ADDomain/All Domains" read "/Groups/$ADGroup" GroupMembership | awk 'BEGIN { RS = "\ " } ; NR >1 ' | tr -d "domain\\")"

for Member in $ADGroupMembers
  do
    memberID="$(dscl "/Active Directory/domain/All Domains" read "/Users/${Member}" RecordName | awk '{ print $2 }')"
    memberName="$(dscl "/Active Directory/domain/All Domains" read "/Users/${Member}" RealName | awk 'FNR==2 { print $1,$2 }')"
    printf "%s,%s\n" \
    "$memberID","$memberName" >> "$userPath/MacLocalAdmin-$NOW-$NOWT.csv"
  done

exit 0
