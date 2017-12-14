#!/bin/bash
# Change MAU to Manual
USERROOT="/Users/*"
for dir in $USERROOT
do
    officeupdate=`defaults read $dir/Library/Preferences/com.microsoft.autoupdate2 HowToCheck`
    if [[ $officeupdate = "Automatic" ]]; then
        /usr/bin/defaults write $dir/Library/Preferences/com.microsoft.autoupdate2 HowToCheck Manual &>/dev/null
	    /usr/bin/defaults write $dir/Library/Preferences/com.microsoft.autoupdate2 LastUpdate -date '2001-01-01T00:00:00Z'
    fi
	/bin/chmod 666 $dir/Library/Preferences/com.microsoft.autoupdate2.plist &>/dev/null
done
