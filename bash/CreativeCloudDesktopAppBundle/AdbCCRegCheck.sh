#!/bin/bash
userName="$(ls -la /dev/console | awk '{print $3}')"
AdbFS="/Users/$userName/Library/Application Support/Adobe/OOBE/filesync.db"

if [[ -e "$AdbFS" ]]; then
	sqlite3 "$AdbFS" "SELECT * FROM users" | tr '[:upper:]' '[:lower:]' | grep -i "$userName@yp.com"
	if [[ $? == 0 ]]; then
		echo "User registered."
	else
		echo "User NOT registered."
	fi
else 
	echo "User NOT registered, file not found."
fi

exit 0
