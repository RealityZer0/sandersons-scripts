#!/bin/sh
# NOT FINISHED
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH

MunkiLogs="/usr/local/corp/tools/CreateMunkiLogs"

if [ -e "$MunkiLogs" ]; then
      /usr/bin/open -F -n -a /Applications/Utilities/Terminal.app "$MunkiLogs"
else
	echo "CreateMunkiLogs does not exist!"
fi

exit 0
