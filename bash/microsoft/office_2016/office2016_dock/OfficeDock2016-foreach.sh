#!/bin/bash

USERNAME="$(ls -la /dev/console | awk '{print $3}')"
PkgRcpt="/var/db/receipts/com.microsoft.package.Microsoft_Excel.app.plist"
if [ -e $PkgRcpt ]; then
	
for USER_HOME in /Users/*
	do
		USER_UID=`basename "${USERHOME}"`
		if [ ! "${USER_UID}" = "Shared" ]; then
			#Excel to Dock
			sudo -u $USERNAME /usr/bin/defaults write "{$USER_HOME}"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft Excel.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

			#Word to Dock
			sudo -u $USERNAME /usr/bin/defaults write "{$USER_HOME}"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft Word.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

			#Powerpoint to Dock
			sudo -u $USERNAME /usr/bin/defaults write "{$USER_HOME}"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft Powerpoint.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

			#Outlook to Dock
			sudo -u $USERNAME /usr/bin/defaults write "{$USER_HOME}"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft Outlook.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
			
			#OneNote to Dock
			sudo -u $USERNAME /usr/bin/defaults write "{$USER_HOME}"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft OneNote.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		fi
			#Restart Dock
			/usr/bin/killall Dock;
		else echo "Exiting. Office 2016 not installed."
	done

fi
exit 0
