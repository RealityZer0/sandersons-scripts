#!/bin/bash
userName=$(who |grep console| awk '{print $1}')
domain="domain"
accountType=$(dscl . -read /Users/${userName} | grep UniqueID | cut -c 11- )
nodeName=$(dscl . -read /Users/${userName} | awk '/^OriginalNodeName:/,/^Password:/' | head -2 | tail -1 | cut -c 2- )
currentDC=$(/usr/libexec/PlistBuddy -c "print 'last used servers':'/Active Directory/${domain}':host" /Library/Preferences/OpenDirectory/DynamicData/Active\ Directory/${domain}.plist)
/bin/echo "${userName}"
/bin/echo "${accountType}"
/bin/echo "${nodeName}"
/bin/echo "${currentDC}"
