#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: AppRequestAuto
# SYNOPSIS: Automate App requests via munki and SCOrch
# APP REQUESTED: MacroMates TextMate 2
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson
# Creation Date 7/21/16
#==========#
# ADDITIONAL INFO:
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#

# Get current AD computer object name
ADComp="$(dsconfigad -show | awk '/Computer Account/ {print $4}')"
# Get current AD computer object name sans $
ADComp_neat="$(dsconfigad -show | awk '/Computer Account/ {print $4}'| tr '[:lower:]' '[:upper:]' | tr -d \$)"
# Get console user
userName="$(ls -la /dev/console | awk '{print $3}')"
# Set current user path
userPath="/Users/$userName/Desktop"
# Today's date
NOW=$(date "+%m%d%Y")
# Today's time
NOWT=$(date "+%H%M%S")
# Remote cifs path
cifsPath="cifs://fdqn.domain/Share/SCOrchMac/"
# App Requested
appRequest="TextMate2"
# App Request Filename
appReqTxt="MacRequest.txt"
# Path to file
appReqPath="/Volumes/SCOrchMac"
# App request failed
appFail="$userPath/$appRequest-failed.txt"
# App request succeeded
appSuccess="$userPath/$appRequest-succeeded.txt"
# App AD Group
appADGroup="Macs-TextMate2"
#==========#
# VARIABLES
#==========#
if ping -c 2 -o "domain.com"; then
	if [[ ! -e "$appReqPath" ]]; then
		sudo -u "userName" open -a "Finder" "$cifsPath"
		chflags hidden "$appReqPath"
	else
		echo "$appReqPath exists."
	fi
else
	touch $appFail
	echo "The app request for $appRequest failed because $HOSTNAME is not on the corporate network. Please connect via DOMAIN wifi, LAN or VPN and try again." > "$appFail"
	exit 1
fi

if [[ ! -e "$appReqPath/$appReqTxt" ]]; then
	touch "$appReqPath/$appReqTxt"
	echo "$userName \ $ADComp_neat \ $appRequest \ $appADGroup" >> "$appReqPath/$appReqTxt"
	echo "The app request for $appRequest succeeded. A ticket has been created on your behalf. You will receive an email shortly" > "$appSuccess"
	## Get the logged in user's password via a prompt
	echo "Prompting ${userName} for their login password."

	cat <<'SCRIPT' > "${TMPDIR}"renewFilevault.scpt
	set currentUser to do shell script "/usr/bin/stat -f%Su /dev/console"

	tell application "System Events" to set fvAuth to text returned of (display dialog "Please enter login password for " & currentUser & ":" default answer "" with title "Login Password" buttons {"OK", "Cancel"} default button 1 with text and hidden answer)

	return fvAuth
SCRIPT

userPass=$(osascript "${TMPDIR}"renewFilevault.scpt)



if [[ ! "$userPass" ]]; then
    echo "User cancelled or blank password."
    exit 1
fi
else
	echo "$appReqTxt exists."
	echo "$userName \ $ADComp_neat \ $appRequest \ $appADGroup" >> "$appReqPath/$appReqTxt"
	echo "The app request for $appRequest succeeded. A ticket has been created on your behalf. You will receive an email shortly" > "$appSuccess"
fi

sleep 3
diskutil unmount force /Volumes/Orchestrator-Mac
exit 0
