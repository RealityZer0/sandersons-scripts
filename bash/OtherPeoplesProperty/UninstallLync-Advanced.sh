#!/bin/bash

# See Microsoft Article ID: 2691870 How to perform a clean uninstall of Lync for Mac 2011
ASROOT=${ASROOT:-sudo}
# Variables and Functions #
VISIBLEUSERS=$(sudo /usr/bin/dscl . list /Users UniqueID | awk '$2 >= 500 && $2 < 100000000000000000 { print $1; }')
function LyncRunningCheck {
ps ax | grep -v grep | grep -i "/Applications/Microsoft Lync.app/Contents/MacOS/Microsoft Lync" > /dev/null
result=$?
if [ "${result}" -eq "1" ] ; then
     echo "`date`: Microsoft Lync is not running."
else
     echo "`date`: Killing Microsoft Lync."
 LyncPID=$(ps -A | grep -m1 "Microsoft Lync" | awk '{print $1}')
 sudo kill -9 $LyncPID
fi
}
# Main Process #

# Check if Lync is running, kill if it is:
LyncRunningCheck
# Delete the application:
rm -rf /Applications/Microsoft\ Lync.app/
echo "`date`: Removed /Applications/Microsoft\ Lync.app/"
rm -f /Library/Preferences/MicrosoftLyncRegistrationDB.plist

# Remove Dock Icon:
for username in $VISIBLEUSERS
do
HOMEFOLDER=$(sudo dscl . -read /Users/$username NFSHomeDirectory | awk '{print $2}')
DOCKSLOTS=$(sudo defaults read $HOMEFOLDER/Library/Preferences/com.apple.dock persistent-apps | grep tile-type | awk '/file-tile/ {print NR}')
for  slot in $DOCKSLOTS
do
DOCKPATH=`sudo /usr/libexec/PlistBuddy -c "print persistent-apps:$[$slot-1]:tile-data:file-data:_CFURLString" $HOMEFOLDER/Library/Preferences/com.apple.dock.plist`
if [[ $DOCKPATH =~ "Microsoft%20Lync.app" ]];
then
sudo /usr/libexec/PlistBuddy -c "Delete persistent-apps:$[$slot-1]" $HOMEFOLDER/Library/Preferences/com.apple.dock.plist
fi
done
echo "`date`: Removed Lync from $username dock"
done
sleep 5
sudo killall Dock -HUP
# Check if Lync is running, kill if it is:
LyncRunningCheck
# Delete the Application:
sudo rm -rf /Applications/Microsoft\ Lync.app/
echo "`date`: Removed /Applications/Microsoft\ Lync.app/"
# Remove Dock Icon:
for username in $VISIBLEUSERS
do
HOMEFOLDER=$(sudo dscl . -read /Users/$username NFSHomeDirectory | awk '{print $2}')
DOCKSLOTS=$(sudo defaults read $HOMEFOLDER/Library/Preferences/com.apple.dock persistent-apps | grep tile-type | awk '/file-tile/ {print NR}')
for  slot in $DOCKSLOTS
do
DOCKPATH=`sudo /usr/libexec/PlistBuddy -c "print persistent-apps:$[$slot-1]:tile-data:file-data:_CFURLString" $HOMEFOLDER/Library/Preferences/com.apple.dock.plist`
if [[ $DOCKPATH =~ "Microsoft%20Lync.app" ]];
then
sudo /usr/libexec/PlistBuddy -c "Delete persistent-apps:$[$slot-1]" $HOMEFOLDER/Library/Preferences/com.apple.dock.plist
fi
done
echo "`date`: Removed Lync from $username dock"
# Remove User Data:
rm -rf $HOMEFOLDER/Library/Preferences/ByHost/MicrosoftLyncRegistrationDB.*.plist
rm -rf $HOMEFOLDER/Library/Preferences/MicrosoftLyncRegistrationDB.plist
rm -rf $HOMEFOLDER/Library/Preferences/com.microsoft.Lync.plist
rm -rf $HOMEFOLDER/Library/Logs/Microsoft-Lync-*.log
rm -rf $HOMEFOLDER/Documents/Microsoft\ User\ Data/Microsoft\ Lync\ Data/
rm -rf $HOMEFOLDER/Documents/Microsoft\ User\ Data/Microsoft\ Lync\ History/
rm -rf $HOMEFOLDER/Keychains/OC_KeyContainer*
echo "`date`: Removed $username's preferences, logs, history and keychains"
# Remove Presence Handler:
HANDLERS=$(sudo /usr/libexec/PlistBuddy -c "print" $HOMEFOLDER/Library/Preferences/com.apple.LaunchServices.plist | grep Dict | awk '{print NR}')
for  handler in $HANDLERS
do
HandlerCheck=`sudo /usr/libexec/PlistBuddy -c "print LSHandlers:$[$handler-1]:LSHandlerRollAll" $HOMEFOLDER/Library/Preferences/com.apple.LaunchServices.plist`
if [[ $HandlerCheck =~ "com.microsoft.lync" ]];
then
sudo /usr/libexec/PlistBuddy -c "Delete LSHandlers:$[$handler-1]" $HOMEFOLDER/Library/Preferences/com.apple.LaunchServices.plist
echo "`date`: $username x-mspresence handler removed."
fi
done
done
sleep 5
sudo killall Dock -HUP
exit 0