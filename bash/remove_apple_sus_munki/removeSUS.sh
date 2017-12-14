#!/bin/sh
################################################################################
# Read defaults for ManagedInstalls.plist located in /var/root/
# and
SUS="http://applesus.domain.com/index.sucatalog"
READVAR="$(/usr/bin/defaults read /var/root/Library/Preferences/ManagedInstalls.plist SoftwareUpdateServerURL)"
# If the defaults read returns a value then delete the key
if [ "$READVAR" == "$SUS" ]; then
	/usr/bin/defaults delete /var/root/Library/Preferences/ManagedInstalls.plist SoftwareUpdateServerURL
	else
		echo "http://applesus.domain.com/index.sucatalog NOT present."
fi
################################################################################
# Read defaults for ManagedInstalls.plist located in /Library/Preferences
READLIB="$(/usr/bin/defaults read /Library/Preferences/ManagedInstalls.plist SoftwareUpdateServerURL)"
# If the defaults read returns a value then delete the key
if [ "$READLIB" == "$SUS" ]; then
	/usr/bin/defaults delete /Library/Preferences/ManagedInstalls.plist SoftwareUpdateServerURL
	else
		echo "http://applesus.domain.com/index.sucatalog NOT present."
fi
################################################################################
# Read defaults for com.apple.SoftwareUpdate.plist located in /Library/Preferences
READSUS="$(/usr/bin/defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist CatalogURL)"
# If the defaults read returns a value then delete the key
if [ "$READSUS" != "$SUS" ]; then
	/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate CatalogURL http://applesus.domain.com/index.sucatalog
	else
		echo "http://applesus.domain.com/index.sucatalog present."
fi

exit 0
