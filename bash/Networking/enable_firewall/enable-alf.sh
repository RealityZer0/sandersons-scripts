#!/bin/sh

# Check firewall state
ALF=$(/usr/bin/defaults read "/Library/Preferences/com.apple.alf" globalstate)
LOGGER="/usr/bin/logger"

if [[ ${ALF} = 1 ]]; then
${LOGGER} "Firewall Enabled"
	exit 0
fi

if [[ ${ALF} != 1 ]]; then
${LOGGER} "Enabling Firewall"

    # unload alf
    /bin/launchctl unload /System/Library/LaunchDaemons/com.apple.alf.agent.plist &>/dev/null
    /bin/launchctl unload /System/Library/LaunchAgents/com.apple.alf.useragent.plist &>/dev/null

    # enable firewall
	/usr/bin/defaults write /Library/Preferences/com.apple.alf globalstate -int 1 &>/dev/null


	# load alf
	/bin/launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist &>/dev/null
	/bin/launchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist &>/dev/null
fi

exit 0
