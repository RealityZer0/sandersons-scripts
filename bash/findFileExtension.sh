#!/bin/sh
#Example of find command
searchOLM="$(find /Users -iname "*.olm" -exec ls -lh {} \;)"

if [[ ! -z "$searchOLM" ]]; then
	echo "OLMs found!. Printing list."
	find /Users -iname "*.olm" -exec ls -lh {} \; | awk '{ print $9, $5 }'
	else
		echo "No OLMs found."
fi
exit 0
