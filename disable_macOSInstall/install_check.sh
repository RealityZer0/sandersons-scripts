#!/bin/sh

OS_VERS="$(sw_vers | awk '/ProductVersion/ {print $2}')"

if [[ "$OS_VERS" > "10.11" ]]; then
	echo "macOS Sierra is installed. Sending report."
else
	echo "macOS Sierra is NOT installed. Checking for files."
	echo "Checking installs receipt..."
	defaults read /var/db/receipts/com.domain.RemoveSierra.plist PackageVersion
	if [ $? -ne 0 ]; then
		echo "Receipt not found, installing..."
		exit 0
	else
		if [[ "$remSierra_vers" < "1.0"  ]]; then
			echo "Previous version detected, installing..."
			exit 0
		fi
	fi
fi

exit 1
