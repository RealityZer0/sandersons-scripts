#!/bin/sh

remSierra="/var/db/receipts/com.yp.RemoveSierra.plist"
if [[ -e "$remSierra" ]]; then
	echo "Remove Sierra detected, uninstalling..."
		exit 0
fi
exit 1
