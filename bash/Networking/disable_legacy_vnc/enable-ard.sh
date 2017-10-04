#!/bin/bash
KICKSTART="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
$KICKSTART -uninstall -settings -prefs
$KICKSTART -restart -agent -console
#CUR_USER=`/usr/bin/logname`
$KICKSTART -configure -clientopts -setvnclegacy -vnclegacy no -setdirlogins -dirlogins yes -setreqperm -reqperm yes -setmenuextra -menuextra no -allowAccessFor -allUsers -privs -all 
$KICKSTART -restart -agent