#!/bin/bash
DSPassInterval="$(dsconfigad -show |grep "Password change interval"|awk '{print $5}')"
if [ $DSPassInterval -lt 1 ]; then
/usr/sbin/dsconfigad -passinterval 30
else
	echo "DSConfigAD Password Interval not changed"
fi

exit 0


