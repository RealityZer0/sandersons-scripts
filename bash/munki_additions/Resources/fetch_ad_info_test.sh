#!/bin/sh
# Author: Heig Gregorian
# Editor: Scott Anderson

# This condition_script supplies:
# aduser_groups (array): a list of AD groups the current user is a member of.
# adcomputer_groups (array): a list of AD groups this machine is a member of.

# Requirements:
# AD policy groups setup where this machine is a member

# Usage:
# To have awesome_package install only when this machine is a member of
# the 'awesome_computers' AD group use the following condition:
#
#
# (case and diacritic insensitive)
# <key>conditional_items</key>
# <array>
# 	<dict>
#		<key>condition</key>
#		<string>ANY adcomputer_groups MATCHES[cd] 'awesome_computers'</string>
#		<key>managed_installs</key>
#		<array>
#			<string>awesome_package</string>
#		</array>
#	</dict>
# </array>
computer_name="$(systemsetup -getcomputername | awk '{ print $3 }')"
current_user="$(ls -la /dev/console | awk '{print $3}')"
plist_loc="/Library/Managed Installs/ConditionalItems"
ad_plist_loc="/Library/Managed Installs/ADGroups"




IFS=$'\n'

ad_domain=($(dsconfigad -show | awk '/Active Directory Domain/ {print $5}'))
aduser_groups=($(dscl '/Active Directory/DOMAIN/domain.com' -read /Users/"$current_user"/ memberOf 2>/dev/null | awk ' { FS = "[=,]" ; print $2 }'))
adcomputer_groups=($(dscl '/Active Directory/DOMAIN/domain.com' -read /Computers/"$computer_name"$ memberOf 2>/dev/null | awk '{ FS = "[=,]" ; print $2 }'))

defaults write "$plist_loc" "ad_domain" -array "${ad_domain[@]}"
defaults write "$plist_loc" "aduser_groups" -array "${aduser_groups[@]}"
defaults write "$plist_loc" "adcomputer_groups" -array "${adcomputer_groups[@]}"
defaults write "$plist_loc" "current_user" -array "${current_user[@]}"
defaults write "$plist_loc" "computer_name" -array "${computer_name[@]}"
defaults write "$ad_plist_loc" "current_user" -array "${current_user[@]}"
defaults write "$ad_plist_loc" "computer_name" -array "${computer_name[@]}"
defaults write "$ad_plist_loc" "ad_domain" -array "${ad_domain[@]}"
defaults write "$ad_plist_loc" "aduser_groups" -array "${aduser_groups[@]}"
defaults write "$ad_plist_loc" "adcomputer_groups" -array "${adcomputer_groups[@]}"
plutil -convert xml1 "$plist_loc".plist
plutil -convert xml1 "$ad_plist_loc".plist



exit 0
