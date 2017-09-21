#!/bin/bash
userName=`ls -la /dev/console | awk '{print $3}'`
/usr/bin/find ~ $TMPDIR.. \( -flags +sappnd,schg,uappnd,uchg -o ! -user $userName -o ! -perm -600 \) 2>&- | wc -l | pbcopy > /Users/$userName/Desktop/$userName-PermsLocks.txt
