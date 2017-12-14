#!/bin/sh
#==========#
# ABOUT THIS SCRIPT
# NAME: EnableSysPrefAdm
# SYNOPSIS: Enables Require an administrator password to access system-wide preferences
#==========#
# HISTORY:
# Version 1.1
# Created by RTrouton
# Creation Date ???
# Revised by Scott Anderson
#==========#
# ADDITIONAL INFO: by RTrouton of derflounder.com
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/scripts;/usr/local/munki
export PATH
#==========#
# Dump authdb read to tmp directory
/bin/mkdir /temp
/usr/bin/security authorizationdb read system.preferences.security > /temp/sysprefs.plist
# Modify the shared key which equals Require and administrator password to access system-wide preferences
/usr/bin/defaults write /temp/sysprefs.plist shared -bool false
# Write the modified plist back to the authdb
/usr/bin/security authorizationdb write system.preferences < /temp/sysprefs.plist
/bin/rm -rf /temp
