#!/bin/sh
# Pull current logged in user into 'user' variable.
userName="$(ls -la /dev/console | awk '{print $3}')"

# #2 Kill Lync & SfB
killall "Microsoft Lync"
killall "Skype for Business"

# #3 Delete the Lync & SfB applications
rm -rf "/Applications/Microsoft Lync.app"
rm -rf "/Applications/Skype For Business.app"

# #4 Delete caches, cookies, OC_KeyContainer, preferences, receipts & logs (if present) 
rm -f "/Users/$userName/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.lync.sfl"
rm -f "/Users/$userName/Library/Cookies/com.microsoft.Lync.binarycookies"
rm -f "/Users/$userName/Library/Caches/com.microsoft.Lync"
rm -rf "/Users/$userName/Library/Group Containers/UBF8T346G9.Office/Lync"
rm -f "/Users/$userName/Library/Logs/"Microsoft-Lync*
rm -f "/Users/$userName/Library/Preferences/"ByHost/MicrosoftLync*
rm -f "/Users/$userName/Library/Preferences/com.microsoft.Lync.plist"
rm -f "/Users/$userName/Library/Receipts/Lync.Client.Plugin.plist"
rm -f "/Users/$userName/Library/Preferences/com.microsoft.SkypeForBusinessTAP.plist"
rm -rf "/Users/$userName/Library/Logs/com.microsoft.SkypeForBusinessTAP"
rm -rf "/Users/$userName/Library/Application Support/Skype for Business"
rm -f "/Users/$userName/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.skypeforbusinesstap.sfl"
rm -rf "/Users/$userName/Library/Application Support/com.microsoft.SkypeForBusinessTAP"
rm -f "/Users/$userName/Library/Cookies/com.microsoft.SkypeForBusinessTAP.binarycookies"

# #5 Delete Lync & Skype User Data (but keep Lync Conversation History)
rm -rf "/Users/$userName/Documents/Microsoft User Data/Microsoft Lync Data" 
rm -rf "/Users/$userName/Documents/Microsoft User Data/Microsoft/Communicator"

# #6 remove this file from the Keychains folder and therefore, the Keychain
rm "/Users/$userName/Library/Keychains"/OC_KeyContainer*

# #7 Delete the following KeyChain entry using security command
# $user variable is still in place from earlier

# Pull current logged in user's e-mail address into 'userEmail' variable.
userEmail=$(dscl . -read /Users/$userName EMailAddress | awk '{print $2}')
security delete-certificate -c $userEmail /Users/$userName/Library/Keychains/login.keychain
security delete-generic-password -l "OC_KeyContainer__$userEmail" /Users/$userName/Library/Keychains/login.keychain

exit 0
