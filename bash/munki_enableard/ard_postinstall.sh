#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: EnableARD_munki
# SYNOPSIS: This will run as a munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson on 3/29/16
# Revision Date
#==========#
# ADDITIONAL INFO:
# Parts of this were borrowed from Greg Neagle
# http://scriptingosx.com/category/munki/
# # use kickstart to enable full Remote Desktop access
# for more info, see: http://support.apple.com/kb/HT2370
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#

#enable ARD access
KICKSTART="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
$KICKSTART -uninstall -settings -prefs
$KICKSTART -restart -agent -console
-configure -access -on -users macadmin -privs -all
$KICKSTART -configure -clientopts -setvnclegacy -vnclegacy no -setdirlogins -dirlogins yes -setreqperm -reqperm yes -setmenuextra -menuextra no -allowAccessFor -specifiedUsers
$KICKSTART -restart -agent
$KICKSTART -activate

exit 0