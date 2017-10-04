#!/bin/bash
/usr/bin/find ~ $TMPDIR.. -exec chflags -h nouchg,nouappnd,noschg,nosappnd {} + \
-exec chown -h $UID {} + -exec chmod +rw {} + \
-exec chmod -h -N {} + -type d \
-exec chmod -h +x {} + 2>&-
