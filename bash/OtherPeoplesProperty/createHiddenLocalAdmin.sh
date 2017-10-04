#!/bin/sh
#
# IMPORTANT:
# *** This script is provided as a proof-of-concept ONLY.
#
# README:
# - Creates a Hidden Local Admin on Mac Systems
#
#
# REFERENCE LINKS:
# - http://support.apple.com/kb/HT5017
# - http://web.rebootcs.com/hints/10-apple/37-create-hidden-account
# - http://community.centrify.com/t5/The-Centrify-Apple-Guys/How-to-create-a-Hidden-Local-Admin-account-on-Mac-systems-Redux/ba-p/14649
#
#
# Last update: 02/01/2014
# Modified by Scott Anderson 10/29/15


# *** ************************************************************************* ***
# *** Edit this to your own preferences **************************************** ***

HIDDEN_USER="admin"
HIDDEN_PASS="password"
HIDDEN_UID="300"
HIDDEN_NAME='admin'

# *** ************************************************************************* ***
# *** ************************************************************************* ***


# *** ************************************************************************* ***
# Do not edit below this line
# *** ************************************************************************* ***

HIDDEN_HOME="/var/home/$HIDDEN_USER"

# 1. Check for local account
MACCHK="$(/usr/bin/dscl . -read /Users/macadmin | grep RealName | awk '{print $2}')" &>/dev/null

# Create the new account
if [ "$MACCHK" != "${HIDDEN_USER}" ]; then
	/usr/bin/dscl . -create /Users/$HIDDEN_USER UniqueID $HIDDEN_UID &>/dev/null
	/usr/bin/dscl . -create /Users/$HIDDEN_USER PrimaryGroupID 80 &>/dev/null
	/usr/bin/dscl . -create /Users/$HIDDEN_USER NFSHomeDirectory "$HIDDEN_HOME" &>/dev/null
	/usr/bin/dscl . -create /Users/$HIDDEN_USER UserShell /bin/bash &>/dev/null
	/usr/bin/dscl . -create /Users/$HIDDEN_USER RealName "$HIDDEN_NAME" &>/dev/null
	/usr/bin/dscl . -passwd /Users/$HIDDEN_USER $HIDDEN_PASS &>/dev/null
	/bin/mkdir "$HIDDEN_HOME" &>/dev/null
	/usr/sbin/chown -R $HIDDEN_USER "$HIDDEN_HOME" &>/dev/null

	echo "Creating Macadmin account" &>/dev/null
else
	echo "Macadmin account already exists"; exit 0 &>/dev/null
fi

# 4. Check and add macadmin to admin groupmember
# Variable to check admin groupmember
DSEDMACADM="$(/usr/sbin/dseditgroup -o checkmember -m ${HIDDEN_USER} admin|awk 'FNR == 1 {print $1}')" &>/dev/null
# Check macadmin is admin groupmember if not then add
if [ "$DSEDMACADM" == "no" ]; then
/usr/sbin//usr/sbin/dseditgroup -o edit -a ${HIDDEN_USER} -t user admin; echo "Adding macadmin to Admin GroupMember" &>/dev/null
else
	echo "${HIDDEN_USER} is a member of Admins group"; exit 0 &>/dev/null
fi

# 5. Check and add macadmin to admin groupmembership
# Varible to check admin groupmembership
MACADMGRPMEM="$(/usr/bin/dscl . -read /groups/admin GroupMembership | grep -oiw "${HIDDEN_USER}" | wc -w | awk '{print $1}')" &>/dev/null
# Check macadmin is admin groupmembership if not then add
if [ "$MACADMGRPMEM" -lt 1 ]; then
/usr/bin/dscl . -append /groups/admin GroupMembership ${HIDDEN_USER}; echo "Adding Macadmin to Admin GroupMembership" &>/dev/null
else
	echo "${HIDDEN_USER} is a member of Admin groups"; exit 0 &>/dev/null
fi

exit 0
