#!/bin/sh

remSierra="/var/db/receipts/com.domain.RemoveSierra.plist"
if [[ -e "$remSierra" ]]; then
	echo "Remove Sierra detected, uninstalling..."
		exit 0
fi
exit 1
