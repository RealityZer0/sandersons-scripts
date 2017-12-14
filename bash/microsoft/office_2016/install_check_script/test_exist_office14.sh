#!/bin/bash
WordVer="$(defaults read "/Applications/Microsoft Word.app/Contents/Info.plist" CFBundleShortVersionString)"
Office14="/Applications/Microsoft Office 2011/"

#Compare Word Version needed to install
if [[ -e $Office14 && "$WordVer" < "15" ]]; then 
	echo "Office 2011 is installed"
    exit 0
else 
    echo "Office 2016 is installed"
	exit 1
fi