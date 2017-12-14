#!/bin/sh

#### Gets your Munki repo's IP address, which may change depending on whether the client is connected to your network internally or not

## Fill in your Munki repo's fqdn
MUNKI_REPO='munki.domain.com'

## Borrowing some variable setup from Tim Sutton: https://github.com/timsutton/munki-conditions
DEFAULTS=/usr/bin/defaults
MUNKI_DIR=$($DEFAULTS read /Library/Preferences/ManagedInstalls ManagedInstallDir)
COND_DOMAIN="$MUNKI_DIR/ConditionalItems"

## Getting the IP address of the Munki repo domain name
MUNKI_REPO_IP=$(nslookup "$MUNKI_REPO" | grep "Address: " | awk '/Address: / {print $2}')

## Writing back the fetched IP address
$DEFAULTS write "$COND_DOMAIN" munki_repo_ip -string "$MUNKI_REPO_IP"

exit 0
