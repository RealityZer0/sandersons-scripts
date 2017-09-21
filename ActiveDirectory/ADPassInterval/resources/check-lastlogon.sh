#!/bin/bash
#Check Active Directory last logon attribute
#VARIABLES
adComputer="$(dsconfigad -show | awk '/Computer Account/ {print $4}')"
domain="domain.com"
lastLogon="$(/usr/bin/dscl "/Active Directory/CORP/${domain}" -read /Computers/${adComputer} | awk '/lastLogonTimestamp/ {print $2}')"
lastLogonCvrt=$((lastLogon/10000000-11644473600))
lastLogonDate="$(/bin/date -j -f %s ${lastLogonCvrt})"
todayEpoch="$(/bin/date +%s)"
objChange="$(/usr/bin/dscl "/Active Directory/CORP/${domain}" -read /Computers/${adComputer} | awk '/whenChanged/ {print $2}'| cut -c 1-14)"
objChangeCvrt=$(/bin/date -j -f '%Y%m%d%H%M%S' +%s "${objChange}")
objChangeDate="$(/bin/date -j -f %s ${objChangeCvrt})"
expEpoch="$((OBJ_CHANGE_CONVERT+7776000))"
expCvrt="$(/bin/date -j -f %s ${expEpoch})"

#COMMANDS
if [ "${lastLogonCvrt}" -gt "${expEpoch}" ]; then
	echo "The AD computer object has expired. Computer object last logon is ${lastLogonDate} and the expiration date is ${expCvrt}."
else
	echo "The AD computer object has not expired. Computer object last logon is ${lastLogonDate} and the expiration date is ${expCvrt}."
fi

exit 0
