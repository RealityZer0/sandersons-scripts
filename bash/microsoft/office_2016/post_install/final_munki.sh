#!/bin/bash

# Change MAU to Manual
for USERROOT in /Users/*
	do
		USERUID=`basename "${USERROOT}"`
		if [ ! "${USERUID}" = "Shared" ]; then
    	    /usr/bin/defaults write "$USERROOT"/Library/Preferences/com.microsoft.autoupdate2 HowToCheck Manual &>/dev/null
	    	/usr/bin/defaults write "$USERROOT"/Library/Preferences/com.microsoft.autoupdate2 LastUpdate -date '2001-01-01T00:00:00Z'
		fi
		/bin/chmod 666 "$USERROOT"/Library/Preferences/com.microsoft.autoupdate2.plist &>/dev/null
	done

#Find Current User
CurrentUser=`/usr/bin/who | awk '/console/{ print $1 }'`

#Set Command Variable for trusted application
register_trusted_cmd="/usr/bin/sudo -u $CurrentUser /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted"

#Set Variable for application being run against
application="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft AU Daemon.app"

#This runs the combination of variables above that will block the running
#of the autoupdate.app until the user actually clicks on it, or goes
#into the help check for updates menu.  Additionally this needs to be
#run for each user on a machine.
$register_trusted_cmd "$application"


## Outlook
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook HideFoldersOnMyComputerRootInFolderList -bool true
#/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook kSubUIAppCompletedFirstRunSetup1507 -bool true
#/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook FirstRunExperienceCompletedO15 -bool true
#/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook OUIWhatsNewLastShownLink -integer 717794
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook SendAllTelemetryEnabled -bool false


## Powerpoint
/usr/bin/defaults write /Library/Preferences/com.microsoft.PowerPoint kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.PowerPoint OUIWhatsNewLastShownLink -integer 717793
/usr/bin/defaults write /Library/Preferences/com.microsoft.PowerPoint SendAllTelemetryEnabled -bool false

## Excel
/usr/bin/defaults write /Library/Preferences/com.microsoft.Excel kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.Excel OUIWhatsNewLastShownLink -integer 717791
/usr/bin/defaults write /Library/Preferences/com.microsoft.Excel SendAllTelemetryEnabled -bool false

## Word
/usr/bin/defaults write /Library/Preferences/com.microsoft.Word kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.Word OUIWhatsNewLastShownLink -integer 708559
/usr/bin/defaults write /Library/Preferences/com.microsoft.Word SendAllTelemetryEnabled -bool false

## OneNote
/usr/bin/defaults write /Library/Preferences/com.microsoft.onenote.mac kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.onenote.mac SendAllTelemetryEnabled -bool false
/usr/bin/defaults write /Library/Preferences/com.microsoft.onenote.mac FirstRunExperienceCompletedO15 -bool true

# How do I get those codes?
# defaults read -app "/Applications/Microsoft Excel.app"
# repeat for each app

for USER_HOME in /Users/*
	do
		USER_UID=`basename "${USER_HOME}"`
		if [ ! "${USER_UID}" = "Shared" ]; then
			#Excel to Dock
			sudo -u $USER_UID /usr/bin/defaults write "$USER_HOME"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft Excel.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

			#Word to Dock
			sudo -u $USER_UID /usr/bin/defaults write "$USER_HOME"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft Word.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

			#Powerpoint to Dock
			sudo -u $USER_UID /usr/bin/defaults write "$USER_HOME"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft Powerpoint.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

			#Outlook to Dock
			sudo -u $USER_UID /usr/bin/defaults write "$USER_HOME"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft Outlook.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
			
			#OneNote to Dock
			sudo -u $USER_UID /usr/bin/defaults write "$USER_HOME"/Library/Preferences/com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict> <key>file-data</key><dict><key>_CFURLString</key><string>Applications/Microsoft OneNote.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		fi
			#Restart Dock
			/usr/bin/killall Dock
	done

exit 0