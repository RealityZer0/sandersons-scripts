#!/bin/sh
#==========#
# ABOUT THIS SCRIPT:
# NAME: OS_installcheck
# SYNOPSIS: Bypass the /var/db/receipts for install
#==========#
# HISTORY:
# Version 1.0
# Created by Scott Anderson on 12/19/17
# Revision Date
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH
#==========#
# VARIABLES
#==========#
OS_VERS="$(sw_vers | awk '/ProductVersion/ {print $2}')"

if [[ "$OS_VERS" = "10.13" ]]; then
	exit 0
fi
echo "Not High Sierra 10.13"
exit 1
