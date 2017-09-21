#!/bin/sh

osMajor="$(sw_vers | awk '/ProductVersion/ {print $2}'| cut -c 1-5)"
version="10.x"
prodVers="$(defaults read /System/Library/CoreServices/SystemVersion.plist ProductVersion)"

if [[ $osMajor = "${version}" && $prodVers < "10.x.x" ]]; then
	echo " Install macOS update"
	exit 0
else
	echo "Update not supported for your OS version"
fi

exit 1
