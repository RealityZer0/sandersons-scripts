#!/bin/sh

USERNAME="$(ls -la /dev/console | awk '{print $3}')"

/usr/bin/mcxrefresh -n "$USERNAME" 

exit 0