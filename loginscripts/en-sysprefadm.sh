#!/bin/bash

#Enable Require and administrator password to access system-wide preferences
#Step 1 dump authdb read to tmp directory
/bin/mkdir /temp
/usr/bin/security authorizationdb read system.preferences.security > /temp/sysprefs.plist
#step 2 modify the shared key which equals Require and administrator password to access system-wide preferences
/usr/bin/defaults write /temp/sysprefs.plist shared -bool false
#step 3 write the modified plist back to the authdb
/usr/bin/security authorizationdb write system.preferences < /temp/sysprefs.plist
/bin/rm -rf /temp
