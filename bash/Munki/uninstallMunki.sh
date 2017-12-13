#!/bin/bash
#==========#
# ABOUT THIS SCRIPT:
# NAME: Uninstall Munki
# SYNOPSIS: Uninstall all files/folders involving Munki.
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson on 12/12/17
# Revision Date
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
TARGET_VOL="$3"
#==========#
# COMMANDS
#==========#
launchctl unload /Library/LaunchDaemons/com.googlecode.munki.*

rm -rf "/Applications/Utilities/Managed Software Update.app"
#Munki 2 only:
rm -rf "/Applications/Managed Software Center.app"

rm -f /Library/LaunchDaemons/com.googlecode.munki.*
rm -f /Library/LaunchAgents/com.googlecode.munki.*
rm -rf "/Library/Managed Installs"
rm -rf /usr/local/munki
rm /etc/paths.d/munki
rm -rf /var/root/Library/Preferences/ManagedInstalls.plist
rm -rf /var/root/Library/munki_manifests
defaults read /var/root/Library/Preferences/ManagedInstalls.plist

pkgutil --forget com.googlecode.munki.admin
pkgutil --forget com.googlecode.munki.app
pkgutil --forget com.googlecode.munki.core
pkgutil --forget com.googlecode.munki.launchd
pkgutil --forget com.yp.YP_Munki_Additions_FULL
