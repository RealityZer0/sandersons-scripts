#!/bin/sh

rm -f /Library/Preferences/com.apple.Bluetooth.plist
for userHome in /Users/*
do 
	userUID=$(basename "${userHome}")
	if [ ! "${userUID}" = "Shared" ]; then
		rm -rf ${userHome}/Library/Preferences/ByHost/com.apple.Bluetooth.*
	fi
done
defaults write com.apple.BluetoothAudioAgent 'Apple Bitpool Min (editable)' 40
killall coreaudio
killall bluetoothaudiod

exit 0