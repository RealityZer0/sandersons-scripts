#!/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki
export PATH
#Check and enable GateKeeper status
GKStatus="$(spctl --status)"
if [[ $GKStatus =~ "enabled" ]]; then
	echo "No changes required."
else
	spctl --master-enable
fi

exit 0