#!/bin/bash
#==========#
# ABOUT THIS SCRIPT:
# NAME: SetLocalAdminRights
# SYNOPSIS: Checks and adds user if member of AD admin group.
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson
# Creation Date 11/09/16
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
# Check logged in console user
userName="$(ls -la /dev/console | awk '{print $3}')"
# Check if groupid belongs to AD groupid
domain="domain.com" #try netbios ID if fails
gID="12345"
domainID="$(/usr/bin/id -G ${userName} | grep -c ${gID})"
# macOS_LAdmin
admGroupUID="5CE21128-C0DB-C3P0-R2D2-0000000000"
osxAdm="$(/usr/bin/dscl . -read /Groups/admin NestedGroups|grep -c "${admGroupUID}")"
# Check user is in groupmembership
userGrpMem="$(/usr/bin/dscl . -read /groups/admin GroupMembership | grep -oiw ${userName} | wc -w | awk '{print $1}')"
# Check local admin membership for user
chkMember="$(/usr/sbin/dseditgroup -o checkmember -m "${userName}" admin|awk 'FNR == 1 {print $1}')"
# Check user is member of Active Directory
queryAD="$(/usr/sbin/dseditgroup -o checkmember -n "/Active Directory/${domain}/All Domains" -m ${userName} -read "macOS_LAdmin"|awk 'FNR == 1 {print $1}')"
# Show User's Local UID
userUID="$(/usr/bin/dscl . -read /Users/${userName} GeneratedUID | awk '{print $2}')"
# Check user is in group members
adminGroup="$(/usr/bin/dscl . -read /Groups/admin GroupMembers | grep -oiw ${userUID} | wc -w | awk '{print $1}')"
#==========#
# COMMANDS
#==========#
#Flushes Open Directory Cache prior to running User/local admin queries
/usr/bin/odutil reset cache

# Checks OSX_Local_Admins is in admin NestedGroups
if [ "${osxAdm}" -lt 1 ]; then
	/usr/bin/dscl . -append /groups/admin NestedGroups "${admGroupUID}"
fi

if [ "${queryAD}" = "no" ]; then
	echo "${userName} is NOT a member of Local Admins."
	exit 0
fi

# Check if user is still member of local admins post cache flush
# Add User to admin GroupMembership if not present
if [ "${userGrpMem}" -lt 1 ]; then
	/usr/bin/dscl . -append /groups/admin GroupMembership ${userName}
fi

# Add User as GroupMember to admin
# Queries an AD group to verify Admin rights
if [ "${adminGroup}" -lt 1 ]; then
	/usr/sbin/dseditgroup -o edit -a ${userName} -t user admin
fi


exit 0
