#!/bin/bash
sudo launchctl unload /Library/LaunchDaemons/com.googlecode.munki.*

sudo rm -rf "/Applications/Utilities/Managed Software Update.app"
#Munki 2 only:
sudo rm -rf "/Applications/Managed Software Center.app"

sudo rm -f /Library/LaunchDaemons/com.googlecode.munki.*
sudo rm -f /Library/LaunchAgents/com.googlecode.munki.*
sudo rm -rf "/Library/Managed Installs"
sudo rm -rf /usr/local/munki
sudo rm /etc/paths.d/munki
sudo rm -rf /var/root/Library/Preferences/ManagedInstalls.plist
sudo rm -rf /var/root/Library/munki_manifests
sudo defaults read /var/root/Library/Preferences/ManagedInstalls.plist

sudo pkgutil --forget com.googlecode.munki.admin
sudo pkgutil --forget com.googlecode.munki.app
sudo pkgutil --forget com.googlecode.munki.core
sudo pkgutil --forget com.googlecode.munki.launchd
sudo pkgutil --forget com.yp.YP_Munki_Additions_FULL