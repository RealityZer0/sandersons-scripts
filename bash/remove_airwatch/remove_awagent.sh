#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: RemoveAirWatch
# SYNOPSIS: Remove AirWatch agent and dependencies
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson
# Creation Date 8/11/16
#==========#
# ADDITIONAL INFO:
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
# Grab current console user
userName="$(ls -la /dev/console | awk '{print $3}')"


#Disenroll Airwatch Agent

awAgent="/Applications/VMware AirWatch Agent.app"

if [ ! -e "$awAgent" ]; then
	echo "AWAgent not installed, exiting."
	exit 0
fi

ldaemons=(
/Library/LaunchDaemons/com.airwatch.AWRemoteManagementDaemon.plist
/Library/LaunchDaemons/com.airwatch.AWRemoteTunnelAgent.plist
/Library/LaunchDaemons/com.airwatch.airwatchd.plist
/Library/LaunchDaemons/com.airwatch.awcmd.plist
/Library/LaunchAgents/com.airwatch.mac.agent.plist
)

## Using launchctl, unload daemons
for daemon in ${ldaemons[@]}; do
    /bin/launchctl unload "$daemon" &>/dev/null
done

#Remove LaunchAgents
rm -rf "/Library/LaunchDaemons/com.airwatch.AWRemoteManagementDaemon.plist"
rm -rf "/Library/LaunchDaemons/com.airwatch.AWRemoteTunnelAgent.plist"
rm -rf "/Library/LaunchDaemons/com.airwatch.airwatchd.plist"
rm -rf "/Library/LaunchDaemons/com.airwatch.awcmd.plist"
rm -rf "/Library/LaunchAgents/com.airwatch.mac.agent.plist"

#Remove Profile
sudo profiles -R -p 9c9f77bd-e5ef-4de8-b6d8-030d1fd107b3

#Stop running agent
killall "VMware AirWatch Agent"

#Remove AirWatch files
pkgutil --forget com.air-watch.pkg.OSXAgent

#Delete AirWatch files
rm -rf "/Applications/VMware AirWatch Agent.app"
rm -rf "/Users/$userName/Library/Preferences/com.airwatch.mac.agent.plist"
rm -rf "/Library/Frameworks/AWSocket.dylib"
rm -rf "/Library/Application Support/AirWatch"
defaults delete /var/db/locationd/clients.plist "com.apple.locationd.executable-/Library/Application Support/AirWatch/airwatchd"
defaults delete /var/db/locationd/clients.plist com.airwatch.mac.agent
killall locationd
exit 0


