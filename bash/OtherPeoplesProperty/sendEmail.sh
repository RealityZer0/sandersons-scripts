#!/bin/sh

#  SendHelpDeskRequest.sh
#  Opens user's default mail client to send an email to the HelpDesk. Hooray!
#
#  Created by smashism on 10/3/14.
#  

# getting user information
computerName="$(scutil --get LocalHostName)"
userName="$(ls -la /dev/console | awk '{print $3}')"

# set email information
subject="Munki logs attached for $userName"
body="Hello, my username is $userName and my computer's name is $computerName. Please review the attached munki logs. "

# send email through default mail client
open "mailto:end.user.infrastructure@yp.com?subject=$subject&body=$body"