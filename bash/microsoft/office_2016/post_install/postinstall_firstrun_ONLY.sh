#!/bin/sh

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
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook FirstRunExperienceCompletedO15 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook OUIWhatsNewLastShownLink -integer 717794
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook SendAllTelemetryEnabled -bool false
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook FirstRunExperienceCompletedO15 -bool true

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

exit 0