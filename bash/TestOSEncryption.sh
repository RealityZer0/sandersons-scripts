#!/bin/bash
osVers="$(sw_vers | awk '/ProductVersion/ {print $2}'| cut -c 4-5)"

if [[ ${osVers} -ge "13" ]]; then
  echo "check_encryption_state_apfs"
else
  echo "check_encryption_state_hpfs"
fi
