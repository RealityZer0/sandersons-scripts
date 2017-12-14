#!/bin/bash
ADBIND="/usr/local/scripts/adbinder"
if [ -e $ADBIND ]; then
	/bin/sh $ADBIND
else
	echo "ADBind script does not exist"
fi
exit 0
