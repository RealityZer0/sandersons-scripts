#!/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH


#Cursory munki fixes
fix_munki()
{
	
chown -Rv root:wheel /usr/local/munki
launchctl unload /Library/LaunchDaemons/com.googlecode.munki.logouthelper.plist
launchctl unload /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-check.plist
launchctl unload /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-install.plist
launchctl unload /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-manualcheck.plist
launchctl load -w /Library/LaunchDaemons/com.googlecode.munki.logouthelper.plist
launchctl load -w /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-check.plist
launchctl load -w /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-install.plist
launchctl load -w /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-manualcheck.plist

}

fix_munki

exit 0
