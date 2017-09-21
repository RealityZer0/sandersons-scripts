#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: EnableARD_Admins
# SYNOPSIS: This will run as a munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson on 10/13/16
# Revision Date
#==========#
# ADDITIONAL INFO:
# Parts of this was borrowed from
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
domainGroup1="DOMAIN\Group1"
domainGroup2="DOMAIN\Group2"
#==========#
# COMMANDS
#==========#
dscl . -create /Groups/ard_admin
dscl . -create /Groups/ard_admin PrimaryGroupID "385"
dscl . -create /Groups/ard_admin Password "*"
dscl . -create /Groups/ard_admin RealName "ard_admin"
dscl . -create /Groups/ard_admin GroupMembers ""
dscl . -create /Groups/ard_admin GroupMembership ""

dseditgroup -o edit -n /Local/Default -a "${domainGroup1}" -t group ard_admin
dseditgroup -o edit -n /Local/Default -a "${domainGroup2}" -t group ard_admin
#enable ARD access
KICKSTART="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
$KICKSTART -uninstall -settings -prefs
$KICKSTART -restart -agent -console
$KICKSTART -configure -clientopts -setvnclegacy -vnclegacy no -setdirlogins -dirlogins yes -setreqperm -reqperm yes -setmenuextra -menuextra no -allowAccessFor -specifiedUsers
$KICKSTART -configure -users macadmin -access -on  -privs -all
$KICKSTART -configure -users ard_admin,macadmin -access -on -privs -all
$KICKSTART -restart -agent
$KICKSTART -activate

exit 0
