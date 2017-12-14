#!/bin/bash
#==========#
# ABOUT THIS SCRIPT:
# NAME: Remove Lync 2011
# SYNOPSIS: This will uninstall Lync 2011 as a post install to SfB 2016 for Mac
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson on 11/23/16
# Revision Date
#==========#
# ADDITIONAL INFO:
# Thanks to Marc_grubb
# https://www.jamf.com/jamf-nation/discussions/21843/script-to-remove-lync-2011-skype-for-business-mac-beta
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
userName="$(ls -la /dev/console | awk '{print $3}')"

# Kill Lync process
killall "Microsoft Lync"

# Delete Lync application
rm -rf "/Applications/Microsoft Lync.app"

# Delete caches, cookies, OC_KeyContainer, preferences, receipts & logs (if present)
rm -rf "/Users/${userName}/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.lync.sfl"
rm -rf "/Users/${userName}/Library/Cookies/com.microsoft.Lync.binarycookies"
rm -rf "/Users/${userName}/Library/Caches/com.microsoft.Lync"
rm -rf "/Users/${userName}/Library/Group Containers/UBF8T346G9.Office/Lync"
rm -f "/Users/${userName}/Library/Logs/"Microsoft-Lync*
rm -f "/Users/${userName}/Library/Preferences/ByHost"/MicrosoftLync*
rm -f "/Users/${userName}/Library/Preferences/com.microsoft.Lync.plist"
rm -f "/Users/${userName}/Library/Receipts/Lync.Client.Plugin.plist"
rm -f "/Users/${userName}/Library/Keychains"/OC_KeyContainer*

# Delete Lync User Data (but keep Lync Conversation History)
rm -rf "/Users/$userName/Documents/Microsoft User Data/Microsoft Lync Data"
rm -rf "/Users/$userName/Documents/Microsoft User Data/Microsoft/Communicator"

# Delete the OC_KeyContainer KeyChain entry using security command
userEmail=$(dscl . -read /Users/${userName} EMailAddress | awk '{print $2}')
security find-generic-password -l "OC_KeyContainer__${userEmail}" /Users/${userName}/Library/Keychains/login.keychain

exit 0
