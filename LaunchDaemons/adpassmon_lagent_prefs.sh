#!/bin/bash
userName="$(ls -la /dev/console | awk '{print $3}')"

if [[ $userName = "root" || $userName = "admin" ]]; then
    log "Exiting ADPassMon for $userName logging in."
    exit 0
fi

#Check for ADPassMon.app and exit if not found
if [ ! -d /Applications/ADPassMon.app ]; then
    echo "ADPassMon not found"
    exit 0
fi

#Check for existing launch agent
if [ -f /Users/$userName/Library/LaunchAgents/AD.ADPassMon.plist ]; then
    echo "LaunchAgent for ADPassMon already exists. Removing..."
    rm /Users/$userName/Library/LaunchAgents/AD.ADPassMon.plist
fi

#Write out a LaunchAgent to launch ADPassMon on login
/usr/bin/defaults write /Users/$userName/Library/LaunchAgents/AD.ADPassMon.plist Label AD.ADPassMon
/usr/bin/defaults write /Users/$userName/Library/LaunchAgents/AD.ADPassMon.plist ProgramArguments -array
/usr/bin/defaults write /Users/$userName/Library/LaunchAgents/AD.ADPassMon.plist RunAtLoad -bool YES
/usr/libexec/PlistBuddy -c "Add ProgramArguments: string /Applications/ADPassMon.app/Contents/MacOS/ADPassMon" /Users/$userName/Library/LaunchAgents/AD.ADPassMon.plist
/usr/sbin/chown -R $userName /Users/$userName/Library/LaunchAgents
/bin/chmod 644 /Users/$userName/Library/LaunchAgents/AD.ADPassMon.plist
echo "Created LaunchAgent to launch ADPassMon on login"

#Check for org.pmbuko.ADPassMon.plist and exit if found
if [ -f /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon.plist ]; then
    echo "org.pmbuko.ADPassMon.plist exists"
    exit 0
else

/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon allowPasswordChange -bool true
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon enableKeychainLockCheck -bool true
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon enableNotifications -bool true
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon isBehaviour2Enabled -int 1
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon passwordCheckInterval -int 4
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon prefsLocked -bool true
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon pwPolicy "Your password needs to be at least 8 characters long, contain UPPER and lower case letters, numbers and or special characters. Passwords cannot be any of the passwords you've used in the last 10 instances."
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon pwPolicyButton "I Understand"
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon selectedBehaviour -int 2
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon selectedMethod -int 0
/usr/bin/defaults write /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon warningDays -int 21
/usr/sbin/chown $userName /Users/$userName/Library/Preferences/org.pmbuko.ADPassMon.plist

fi

exit 0
