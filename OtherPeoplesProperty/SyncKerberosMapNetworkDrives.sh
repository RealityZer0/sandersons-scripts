#!/bin/bash

###############################
#
#   General Description:
#   Determines the current logged in user and mounts appropriate network shares
#   Run via LaunchAgent
#   Requires CocoaDialog    
#
#
#   Specific Description:
#   Gathers current logged in user
#   Performs dscl queries to gather AD attributes for user
#   Gathers IP address and SSID if applicable - to determine whether device is on domain
#   Verifies Kerberos ticket - renews if necessary
#   Verifies user is a domain user
#   Mounts logged in user home drive specified in AD record
#   Attempts to mount all common network shares
#
#   Notes:
#   It uses a brute force approach for mounting shared resources - it may not be 
#   an advisable method if you audit access attempts.
#      Credit to [~bentoms] - I adapted a lot of this from his Applescript share mounting script
#      Credit to [~rtrouton] - I used his script logging function from CasperCheck verbatim.
#
#   Exit Codes:
#       0 - normal script completion
#       1 - Device not on GRCS network
#       2 - Reported user is not a domain account
#       3 - User declined to enter authentication credentials
#       4 - Unable to query dscl
#
#   Script is run as user, log files are written per user to the users home directory
#   NOT TESTED WITH FAST USER SWITCHING - MAY NOT WORK AS EXPECTED!!
#
#   Author: Luke Windram
#   Created: 07/28/15
#   Modified: 08/06/15
#   Version: 1.1
#
#
###############################

################################
#
# Variable Assignment Section
#
################################

### Calculated variables

# Capture AD username of current logged in user

USERNAME=$(who |grep console| awk '{print $1}')

### User modifiable variables

# Location of CocoaDialog.app
CD="/private/var/CocoaDialog.app/Contents/MacOS/CocoaDialog"

# For the log_location variable, put the preferred 
# location of the log file for this script. If you 
# don't have a preference, use the default setting

LOG_FOLDER="/Users/$USERNAME/.log/"

if [ ! -e $LOG_FOLDER ]; then
    mkdir $LOG_FOLDER
fi

LOG_LOCATION="$LOG_FOLDER/mountLog"

# servers

HS="hs-server"
MS="ms-server"
IR="es-fp01"
EV="ev-server"
RC="rockford-fp1"
UT="util"
CO="adm-fp01"

################################
#
# Function Section
#
################################

# Function to provide logging of the script's actions to
# the log file defined by the log_location variable

ScriptLogging(){

    DATE=`date +%Y-%m-%d\ %H:%M:%S`
    LOG="$LOG_LOCATION"   
    echo "$DATE" " $1" >> $LOG
}

# Function to pull ip address

IPAddress(){

    for i in $(seq 0 10);
    do
        ipconfig getifaddr en$i
        if [ $? -eq 0 ]; then
            IPshort=$(ipconfig getifaddr en$i | cut -c -5)
            IPfull=$(ipconfig getifaddr en$i)
        fi
    done 
    WIRELESS=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep AirPort: | awk '{print $2}')
    SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk '/ SSID: / {print $2}')

}

# Function to verify IP Address is local and log that address
# exits script if IP is not local

VerifyIP(){

    if [ $IPshort = "10.48" ]; then
        ScriptLogging "HS IP Address detected: $IPfull"
    elif [ $IPshort = "10.49" ]; then
        ScriptLogging "EV IP Address detected: $IPfull"
    elif [ $IPshort = "10.50" ]; then
        ScriptLogging "IR/CO IP Address detected: $IPfull"
    elif [ $IPshort = "10.51" ]; then
        ScriptLogging "MS IP Address detected: $IPfull"
    else
        ScriptLogging "Off Campus address detected: $IPfull"
        DisconnectAll
        ScriptLogging "======== Exiting ========"
        exit 1
    fi

}

# Function to verify user is connected to local SSID and log SSID

VerifySSID(){

if [ "$WIRELESS" != "Off" ]; then
    ScriptLogging "Device connected to $SSID"
    if [ "$SSID" != "GRCS" ]; then
        if [ "$SSID" != "GRCS_A" ]; then
            ScriptLogging "$SSID is not a GRCS SSID"
            DisconnectAll
            ScriptLogging "======== Exiting ========"     
            exit 1
        fi
    fi
else
    ScriptLogging "Not Connected via Wireless"
fi

}

# Function to verify kerberos ticket

CDVerifyTicket(){

/usr/bin/klist | /usr/bin/grep krbtgt
if [ $? = 0 ]; then
    ScriptLogging "Kerberos Ticket valid"
    /usr/bin/kinit -R
    if [ $? != 0 ]; then
        ScriptLogging "Unable to automatically extend Kerberos Ticket"
        ScriptLogging "Manually extending to avoid imminent expiration"
        RenewTicket
    fi
else
    ScriptLogging "Kerberos Ticket expired or non-existent"
    RenewTicket
fi

}

# Function to renew kerberos ticket

RenewTicket(){

AUTHCREDS=$($CD secure-standard-inputbox --title "Authentication Required" --no-newline \
    --informative-text "Enter your password to access GRCS network resources"  --no-cancel \
    --float)


##### commented out area is intended to be used if user is provided the option to cancel above
#if [ $($AUTHCREDS | awk '{print $1}') = 2 ]; then
#   ScriptLogging "$USERNAME chose not to authenticate."
#   ScriptLogging "======== Exiting ========"
#   exit 3
#else

echo $AUTHCREDS | awk '{print $2}' | kinit -l 10h -r 10h --password-file=STDIN
    ScriptLogging "Kerberos Ticket Renewed by user"

}

# Function to mount specified share

Connect(){

    mkdir /Volumes/$2
    echo $1 $2
    mount -t smbfs //$USERNAME@$1/$2 /Volumes/$2
    if [ $? != 0 ]; then
        rmdir /Volumes/$2
        ScriptLogging "Did not mount $1/$2 - Permission Denied"
    else
        $CD bubble --title "Drive Mounted" \
        --text "Successfully connected to $1/$2" \
        --icon "fileserver" \
        --timeout "15"
        ScriptLogging "Mounted $1/$2"
    fi
}

# Function to connected to nested share

HConnect(){

    mkdir /Volumes/Z_drive
    echo $1 $2
    mount -t smbfs //$USERNAME@$1/$2 /Volumes/Z_drive
    if [ $? != 0 ]; then
        rmdir /Volumes/Z_drive
        ScriptLogging "Error: Could not mount $1/$2"
    else
        $CD bubble --title "Drive Mounted" \
        --text "Successfully connected to $1/$2" \
        --icon "fileserver" --timeout "15"
        ScriptLogging "Mounted $1/$2"
    fi
}

# Function to disconnect all network resources

DisconnectAll(){

    cd /Volumes
    for file in .* *; 
    do 
    if [ "$file" != "Macintosh HD" ]; then
        umount /Volumes/"$file"
    fi
    done
    ScriptLogging "Disconnected all currently unused network shares"

}

#################################
#
# Script Section
#
#################################

ScriptLogging "======== Starting Drive Mounting ========" 

# Verify on GRCS network 

IPAddress
VerifyIP
VerifySSID

# Gather AD information from dscl

ACCOUNT_TYPE=$(dscl . -read /Users/$USERNAME | grep UniqueID | cut -c 11- )
NODENAME=$(dscl . -read /Users/$USERNAME | awk '/^OriginalNodeName:/,/^Password:/' | head -2 | tail -1 | cut -c 2- )
ADHOMESERVER=$(dscl "$NODENAME" -read /Users/$USERNAME | grep SMBHome: | cut -c 10- | sed 's_\\_ _g' | awk '{ print $1 }' )
ADSHAREPATH=$(dscl "$NODENAME" -read /Users/$USERNAME | grep SMBHome: | cut -c 10- | sed 's_\\_ _g' | awk '{first = $1; $1 = ""; print $0; }' | sed 's_ __' | sed 's_ _/_g' )

if [ -z $ADHOMESERVER ] || [ -z $ADSHAREPATH ]; then
    ScriptLogging "Unable to query AD for smb home"
    $CD bubble --title "ERROR ENCOUNTERED" \
    --text "Computer must be rebooted to access network resources" \
    --icon "stop" --notimeout
    exit 4
fi

# Check to see if account is an AD Account, if it is not then exit

if [[ "$ACCOUNT_TYPE" -le "500" ]]; then
    ScriptLogging "Account is not a domain account."
    ScriptLogging "UID is $ACCOUNT_TYPE"
    ScriptLogging "======== Exiting ========"
    exit 2
else
    ScriptLogging "$USERNAME is a domain account"
    ScriptLogging "UID is $ACCOUNT_TYPE"
fi

CDVerifyTicket

# Preliminaries out of the way - let's get to work.

DisconnectAll

ScriptLogging "Attempting to mount shares for $USERNAME"

HConnect $ADHOMESERVER $ADSHAREPATH


# Connect to HS shares

Connect $HS HS-Video
Connect $HS HS-Theatre
Connect $HS HS-Staffpub
Connect $HS HS-Public
Connect $HS quicken
Connect $HS HS-Office
Connect $HS HS-Media
Connect $HS HS-Helpdesk
Connect $HS CAW
Connect $HS Athletics
Connect $HS ESS
Connect $HS WinterimSocialMedia

# Connect to MS shares

Connect $MS MS-Video
Connect $MS MS-Staffpub
Connect $MS MS-Public
Connect $MS MS-Office
Connect $MS MS-Media
Connect $MS MS-Yearbook
Connect $MS MS-Handin

# Connect to CO Shares

Connect $CO CO-Staffpub
Connect $CO Library
Connect $CO Development
Connect $CO Admissions
Connect $CO Finance
Connect $CO Instruction

# Connect to IR Shares

Connect $IR IR-Video
Connect $IR IR-Staffpub
Connect $IR IR-Public
Connect $IR IR-Office
Connect $IR IR-Handin

# Connect to EV Shares

Connect $EV EV-Staffpub
Connect $EV EV-Public
Connect $EV EV-Office

# Connect to RCS Shares

Connect $RC RC-Video
Connect $RC RC-Staffpub
Connect $RC RC-Public
Connect $RC RC-Office
Connect $RC RC-Handin

ScriptLogging "======== Exiting ========"

exit 0