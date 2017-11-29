#!/usr/bin/env bash
### DEFINITIONS
## VARIABLES
softwareTitle=exampleScript
sectionTitle=Header
resourceLocation=$(/usr/bin/dirname "$0")
logFolder="/Library/Logs"
logFile="${logFolder}/${softwareTitle}.log"
consoleUser=$(/usr/bin/stat -f %Su '/dev/console')
## FUNCTIONS
# allows log messages to be sent to both syslog and to a static file I can control
writeLog(){ /usr/bin/logger -s -t "${consoleUser} ${softwareTitle} ${sectionTitle}" -p "user.${1}" "$2" 2>> "$logFile"; }
## SUB ROUTINES
# displays a notification, writes the same text to the log
displayNotification(){
    writeLog notice "$1"
    /usr/bin/osascript <<EOT
    tell application (path to frontmost application as text)
        display notification "$1" with title "Mac Setup"
    end tell
EOT
}
# displays a dialog box, writes the same text to the log, aborts the script if the user clicks the "quit" button
displayDialog(){
    writeLog notice "$1"
    /usr/bin/osascript <<EOT
    tell application (path to frontmost application as text)
        display dialog "$1" buttons {"Quit","OK"} default button 2 cancel button 1 with title "Mac Setup" with icon note
    end tell
EOT
    if [[ "$?" = "1" ]]; then
        writeLog err "User opted to exit."
        exit 1
    fi
}
# writes an error to the log, displays an explanation to the user, then exits the script
exitError(){
    writeLog err "$1"
    /usr/bin/osascript <<EOT
    tell application (path to frontmost application as text)
        display dialog "$1" buttons {"Quit"} default button 1 cancel button 1 with title "Mac Setup" with icon stop
    end tell
EOT
exit 1
}
# asks the user to provide a text string response in the field provided, logs their response, allows them to abort the script by clicking "exit"
promptInput(){
    writeLog notice "$1"
    /usr/bin/osascript <<EOT
    tell application (path to frontmost application as text)
        text returned of (display dialog "$1" default answer "$2" buttons {"Quit","OK"} default button 2 cancel button 1 with title "Mac Setup" with icon note)
    end tell
EOT
    if [[ "$?" = "1" ]]; then
        writeLog err "User opted to exit."
        exit 1
    fi
}
# displays a list of possible selectons
promptRegion(){
    writeLog notice "Please select your region:"
	holdingFile=$(mktemp /tmp/region.XXXX)
	for eachRegion in "${availableRegions[@]}"; do
	    echo "$eachRegion" >> "$holdingFile"
	done
    /usr/bin/osascript <<EOT
    set regionFile to do shell script "echo $holdingFile"
    set fileHandle to open for access regionFile
    set regionList to paragraphs of (read fileHandle)
    tell application (path to frontmost application as text)
        return (choose from list regionList with title "Mac Setup" with prompt "Please select your region:")
    end tell
    close access fileHandle
EOT
	rm "$holdingFile"
}
## LOGGING
# if the log folder doens't exist, make it"
[[ -d "$logFolder" ]] || mkdir -p -m 775 "$logFolder"
# make sure the permissions are set correctly on the log folder
[[ $(/usr/bin/stat -f %u "$logFolder") -ne 0 ]] && /usr/sbin/chown -R root "$logFolder"
[[ $(/usr/bin/stat -f %g "$logFolder") -ne 0 ]] && /usr/bin/chgrp -R wheel "$logFolder"
[[ $(/usr/bin/stat -f %p "$logFolder") -ne 40755 ]] && /usr/sbin/chown -R 755 "$logFolder"
# if the log file already exists, and is too big, trash it and start a fresh one
if [[ -e "$logFile" ]]; then
  [[ $(/usr/bin/stat -f %z "$logFile") -ge 1000000 ]] && mv "$logFile" "${logFile}.old"
fi
/usr/bin/touch "$logFile"
# make sure the permission are set correctly on the log file
[[ $(/usr/bin/stat -f %u "$logFile") -ne 0 ]] && /usr/sbin/chown -R root "$logFile"
[[ $(/usr/bin/stat -f %g "$logFile") -ne 0 ]] && /usr/bin/chgrp -R wheel "$logFile"
[[ $(/usr/bin/stat -f %p "$logFile") -ne 100644 ]] && /usr/sbin/chown -R 644 "$logFile"
### BODY
## INITIALIZATION
echo "========" >> "$logFile"
writeLog info "[$(date)] beginning $softwareTitle"
echo "========" >> "$logFile"
# since this is a script for a payloadless package, the progress bar on the install will be insaccurate, warn the user
displayDialog "During this installation, the progress bar and estimated time may not properly reflect the actual status of the installation. This entire setup process should take 7-10 minutes on most systems.\n \nDuring this process, you will be prompted for some information about your account. Please take care that this information is entered correctly, as inaccurate information will prevent this process from completing successfully."
displayNotification "Beginning Mac Prep Operation"
# snip
# removed various install tests that are not relevant to this example
# snip
## USERNAME PROMPT
sectionTitle=Username
usernameConfirmed=0
while [[ "$usernameConfirmed" = 0 ]]; do
# prompt the user for their user name
    enteredUsername=$(promptInput "Please enter your eight-digit User ID:" "01234567")
# since the AppleScript dialog exists in a seporate shell, this line (and those like to follow) force the parent script to exit if the AppleScript dialog fails, or if the user clicks the "quit: button
    [[ "$?" != 0 ]] && exit 1
# this tests if the user either let the window time out, or just clicked okay without changing the default text
    if [[ "$enteredUsername" = '01234567' ]]; then
# if the default text was entered, this displays the prompt again, but with additional clarification about what the user needs to do.
        enteredUsername=$(promptInput "Default text was entered, please replace the default text with your User ID." "01234567")
        [[ "$?" != 0 ]] && exit 1
        if [[ "$enteredUsername" = '01234567' ]]; then
            writeLog warning "User entered default text for first username prompt"
        fi
    fi
# this is a duplicate loop from above, asking the user to enter the text a second time; since there is no real way to validate text entered through AppleScript, the second entry cuts down on typo issues
    confirmUsername=$(promptInput "Please retype your User ID for confirmation." "01234567")
    [[ "$?" != 0 ]] && exit 1
    if [[ "$confirmUsername" = '01234567' ]]; then
        confirmUsername=$(promptInput "Default text was entered, please retype your User ID for confirmation." "01234567")
        [[ "$?" != 0 ]] && exit 1
        if [[ "$confirmUsername" = '01234567' ]]; then
            writeLog warning "User entered default text for User ID confirmation"
        fi
    fi
# this tests if the two entries matched, if they don't, it starts the whole loop over again
    if [[ "$enteredUsername" = '01234567' ]] || [[ "$confirmUsername" = '01234567' ]]; then
        displayDialog "Default text was provided multiple times, please try again."
    elif [[ "$enteredUsername" != "$confirmUsername" ]]; then
        displayDialog "User ID entries did not match, please try again."
# this is additional hardening specific to this usage, since I am asking for a string I know to only be 8 characters, I can test if the entered string meets that criteria
    elif [[ "${#enteredUsername}" != 8 ]]; then
        displayDialog "User ID does not appear to be following established TE format, please try again."
    else
        writeLog info "Confirmed User ID: $enteredUsername"
        (( usernameConfirmed++ ))
        break
    fi
done
# since this is outside of the while-loop, the following tests aren't about the string entered, but rather about the variable, ensuring that the value entered in the text box was correctly picked up and can be used throughout the rest of the script
# this is also an additional check to ensure that someone didn't just walk away for lunch or something, and all of the dialogs above actually had user interaction, not just the default text entered
sectionTitle=Region
if [[ "$enteredUsername" = '01234567' ]] || [[ -z "$enteredUsername" ]]; then
    exitError "An error occured during User ID entry.\n \nPlease restart this process."
else
	writeLog info "User entered employee ID: $enteredUsername"
fi
## REGION LIST
# build an array of all of the possible regions, note the list below is a subset of what I actually use, edited to show functionality
# the array order here is the order the entries will show up in the dialog, so the index number on each array entry matters
availableRegions[0]='United States'
availableRegions[1]='Canada'
availableRegions[2]='China'
availableRegions[3]='France'
availableRegions[4]='Germany'
availableRegions[5]='Italy'
availableRegions[6]='Japan'
availableRegions[7]='United Kingdom'
# build a second array with the various region codes, this will be an associated array used below for file names, so be sure the index numbering lines up
regionCodes[0]='us'
regionCodes[1]='ca'
regionCodes[2]='cn'
regionCodes[3]='fr'
regionCodes[4]='de'
regionCodes[5]='it'
regionCodes[6]='jp'
regionCodes[7]='gb'
## REGION PROMPT
# this is a very similar loop, with similar logic as the user entry above, I can provide detailed descriptions as needed
if [[ -s "${resourceLocation}/regionList.sh" ]]; then
    enteredRegion=0
    source "${resourceLocation}/regionList.sh"
    while [[ "$enteredRegion" = 0 ]]; do
        selectedRegion=$(promptRegion)
        if [[ "$selectedRegion" = false ]]; then
            displayDialog "Installation cannot continue without selecting a region.\n \nPlease click OK to make your selection."
            [[ "$?" != 0 ]] && exit 1
        else
            (( enteredRegion++ ))
            break
        fi
    done
    writeLog info "User selected $selectedRegion"
    for (( i = 0; i < "${#availableRegions[@]}"; i++ )); do
        if [[ "${availableRegions[$i]}" == "$selectedRegion" ]]; then
            regionVariable="${regionCodes[$i]}"
        fi
    done
else
    writeLog info "regionlist.sh not found"
    ls -la "$resourceLocation" >> "$logFile"
    displayNotification "Regional information not available, please provide specifics on your preferred region."
fi
## COUNTRY CODE
# this is just additional hardening to catch in case the country code wasn't picked up correctly, giving the user another chance to enter it manually
if [[ "${#regionVariable}" = 2 ]]; then
    countryCode="$regionVariable"
else
    enteredCountry=0
    while [[ "$enteredCountry" = 0 ]]; do
        countryCode=$(promptInput "Please enter your two-digit country code." "xx")
        [[ "$?" != 0 ]] && exit 1
        if [[ "$countryCode" = 'xx' ]]; then
            countryCode=$(promptInput "Default text was entered, please replace the default text with your two-digit country code." "xx")
            [[ "$?" != 0 ]] && exit 1
        fi
        if [[ "$countryCode" = 'xx' ]]; then
            displayDialog "Default text entered multiple times, please press OK and try again."
        elif [[ "${#countryCode}" != 2 ]]; then
            displayDialog "Country codes must be two digits, please press OK and try again."
        else
            writeLog info "Country Code Entered: $countryCode"
            (( enteredCountry++ ))
            break
        fi
    done
fi
if [[ "$countryCode" = 'xx' ]]; then
    exitError "An error occured during country code.\n \nPlease restart this process."
fi
# snip
# this is where I then use the $countryCode variable to build the filename of the AirWatch profile I want to install with the profiles command
# I cut the script here as I assume you already have the "what to do" portion of your script, your question seemed much more about "how get the info needed to do it"
# if you need help scrafting, or hardening, your specific use case, let me know and I'll be happy to help
# snip
### FOOTER
echo "++++++++" >> "$logFile"
writeLog info "[$(date)] $softwareTitle complete"
echo "++++++++" >> "$logFile"
exit 0
