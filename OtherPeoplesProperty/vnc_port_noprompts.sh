#!/bin/sh

#If you find it useful (or have suggestions, feedback, etc.), shoot me an email at throwapenny@me.com.
#Requires Mac OS 10.7.x or later (tested up to and including 10.10.3)

#Setting Static Variables
sourcepath="/System/Library/LaunchDaemons/"
filename="com.apple.screensharing.plist"
port=`less $sourcepath$filename | awk 'f{print $1;f=0} /SockServiceName/ {f=1}' | awk -F "<|>" '{print $3}'`
os_version=`sw_vers -productVersion`
os_version_aug=`sw_vers -productVersion | awk -F "." '{print $1$2}'`
newport='59900'
LOGGER="/usr/bin/logger"

#Check System Version
sleep 1
if [ "${os_version_aug}" -lt "107" ]; then
echo ""
echo "System OS Must Be 10.7.x or Greater.  Aborting Script."
exit 0
fi

#Give Feedback on Current Port
sleep 1
if [ "${port}" == "vnc-server" ]; then
${LOGGER} "Changing default port"

#echo ""
#echo "The System's VNC Port is Currently"
#echo "Set to the System Default Port of 5900."
#echo "--------"
#elif [ "${port}" != "vnc-server" ]; then
#echo ""
#echo "The System's VNC Port is Currently"
#echo "Set to a Non-default Port of" $port"."
#echo "--------"
#fi

#Updating Port
echo ""
printf "What Port Would You Like VNC to Listen On? "
read newport
echo ""
echo "The Following Action Requires an Admin Password."
echo "Note: Your Password Will Be Visible When You Type It"
echo ""
printf "Admin Password? "
read admin_pass
sleep 1
echo ""
echo "Created" $filename".bak."
sleep 1
echo ""
echo "Updating VNC Port to" $newport"..."
echo $admin_pass | sudo -S sed -i.bak -e "s|$port|$newport|g" $sourcepath$filename
sleep 1
echo "Done"
echo ""
sleep 1

#Restarting screensharing process
echo "Restarting Screen Sharing Service..."
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.screensharing.plist
sudo launchctl load /System/Library/LaunchDaemons/com.apple.screensharing.plist
echo "Done"
sleep 1
echo ""
echo "Your System's VNC Port is Now Set to" $newport"."
echo ""
echo "Update Complete.  All Done."
exit 0