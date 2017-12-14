#!/bin/sh
#==========#
# ABOUT THIS SCRIPT
# NAME: EnableFV2
# SYNOPSIS: Automatically starts Crypt on unencrypted disks during login.
#==========#
# HISTORY:
# Version 1.1
# Created by Graham Gilbert (Possibly?)
# Creation Date ???
# Revised by Scott Anderson
#==========#
# ADDITIONAL INFO: Revised for APFS compatability
#==========#
# PATH
#==========#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/scripts;/usr/local/munki
export PATH
#==========#
# VARIABLES
#==========#
# Automatically starts Crypt on unencrypted disks during login.
osVers="$(sw_vers | awk '/ProductVersion/ {print $2}'| cut -c 4-5)"
readonly BINARY="/usr/local/crypt/Crypt.app/Contents/MacOS/Crypt"

log() {
  echo "${@}" >&2
  logger -t request_encryption "${@}"
}



check_encryption_state_apfs() {

#encCheck="$(diskutil apfs list | awk '/Macintosh HD/ {c=4} c&&c--' | awk '/Encrypted/ {print $3}')" #Valid entry
encCheck="$(diskutil apfs list |  grep -A 3 "Macintosh HD" | awk '/Encrypted/ {print $3}')"
  if [[ ${encCheck} = "Yes" ]]; then
    log "Disk encryption complete, skipping."
    exit 0
  fi

  #encStatus="$(diskutil apfs list | awk '/Macintosh HD/ {c=4} c&&c--'| awk '/Encryption Progress/ {print $4}')"
  encStatus="$(diskutil apfs list | grep -A 3 "Macintosh HD" | awk '/Encryption Progress/ {gsub (":",""); print $2,$3}')"
  #if [[ ${encStatus} =~ ([0-9]?[0-9]?\.[0-9][0-9]?) ]]; then
  if [[ ${encStatus} = "Encryption Progress" ]]; then
    log "Disk encryption in progress, skipping."
    exit 0
  fi

}

check_encryption_state_hfs() {
  diskutil cs list | grep -q -e 'Conversion\ Status.*Pending'
  if [[ ${?} -eq 0 ]]; then
    log "Disk encryption pending, skipping."
    exit 0
  fi

  diskutil cs list | grep -q -e 'Conversion\ Status.*Complete'
  if [[ ${?} -eq 0 ]]; then
    log "Disk encryption complete, skipping."
    exit 0
  fi

  diskutil cs list | grep -q -e 'Conversion\ Status.*Converting'
  if [[ ${?} -eq 0 ]]; then
    log "Disk encrypting or decrypting, skipping."
    exit 0
  fi
}

if [[ $1 = "root" || $1 = "macadmin" || $1 = "admin" ]]; then
  log "Exiting Crypt hook for $1 logging in."
  exit 0
fi

# Replace YOUR_LOCAL_ADMIN_ACCOUNT here if you want to allow such accounts to bypass this check.
main() {
  if [[ ${osVers} -le "12" ]]; then
    check_encryption_state_hpfs
  else
    check_encryption_state_apfs
  fi

  if [ -f ${BINARY} ]; then
    cd /tmp
    ${BINARY}
    BINARY_EXIT=${?}
    log "Crypt exited with ${BINARY_EXIT}"
  else
    log "Crypt doesn't exist! Please contact helpdesk!"
    echo "Crypt doesn't exist! Please visit helpdesk!"
    sleep 10
    exit 1
  fi

  # Here, we've either already bailed out, or failed, soooo...
  echo "Crypt couldn't encrypt your disk."
  echo "Please contact helpdesk immediately!"
  sleep 30
}


main "${@}"
