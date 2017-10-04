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
# Parts of this were borrowed from Armin Briegel
# http://scriptingosx.com/category/munki/
# adapted scripts from  here: https://jamfnation.jamfsoftware.com/discussion.html?id=1989
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
ardrunning=$(ps ax | grep -c -i "[Aa]rdagent")
# All Users access should be off
all_users=$(defaults read /Library/Preferences/com.apple.RemoteManagement ARD_AllLocalUsers 2>/dev/null)

if [[ $ardrunning -eq 0 ]]; then
	echo "ARD not running"
	exit 0
fi

if [[ $all_users -eq 1 ]]; then
	echo "All Users Access Enabled"
	exit 1
fi

echo "Everything looks great!"

exit 1