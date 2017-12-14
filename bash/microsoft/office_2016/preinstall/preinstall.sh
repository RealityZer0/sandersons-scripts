#!/bin/sh
	/usr/bin/killall Microsoft Database Daemon &>/dev/null
	/usr/bin/killall Microsoft AU Daemon &>/dev/null
    /usr/bin/killall Microsoft\ Outlook
    /usr/bin/killall Microsoft\ Excel
    /usr/bin/killall Microsoft\ PowerPoint
    /usr/bin/killall killall Microsoft\ Word
    /bin/rm -Rf '/Library/Application Support/Microsoft/MAU2.0' &>/dev/null
    /bin/rm -Rf '/Library/Application Support/Microsoft/MERP2.0' &>/dev/null
	/bin/rm -R '/Applications/Microsoft Communicator.app/' &>/dev/null
	/bin/rm -R '/Applications/Microsoft Messenger.app/' &>/dev/null
	/bin/rm -Rf '/Applications/Microsoft Office 2011/' &>/dev/null
	/bin/rm -R '/Applications/Remote Desktop Connection.app/' &>/dev/null
	/bin/rm -R /Library/Automator/*Excel* &>/dev/null
	/bin/rm -R /Library/Automator/*Office* &>/dev/null
	/bin/rm -R /Library/Automator/*Outlook* &>/dev/null
	/bin/rm -R /Library/Automator/*PowerPoint* &>/dev/null
	/bin/rm -R /Library/Automator/*Word* &>/dev/null
	/bin/rm -R /Library/Automator/*Workbook* &>/dev/null
	/bin/rm -R '/Library/Automator/Get Parent Presentations of Slides.action' &>/dev/null
	/bin/rm -R '/Library/Automator/Set Document Settings.action' &>/dev/null
	/bin/rm -R /Library/Fonts/Microsoft/ &>/dev/null
	/bin/rm -R '/Library/Application Support/Microsoft/MAU2.0/' &>/dev/null
	/bin/rm -R '/Library/Application Support/Microsoft/MERP2.0/' &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Arial Bold Italic.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Arial Bold.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Arial Italic.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Arial.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Brush Script.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Times New Roman Bold Italic.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Times New Roman Bold.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Times New Roman Italic.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Times New Roman.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Verdana Bold Italic.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Verdana Bold.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Verdana Italic.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Verdana.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Wingdings 2.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Wingdings 3.ttf' /Library/Fonts &>/dev/null
	/bin/mv '/Library/Fonts Disabled/Wingdings.ttf' /Library/Fonts &>/dev/null
	/bin/rm  -R /Library/Internet\ Plug-Ins/SharePoint* &>/dev/null
	/bin/rm  -R /Library/LaunchDaemons/com.microsoft.office.* &>/dev/null
	/bin/rm  -R /Library/Preferences/com.microsoft.* &>/dev/null
	/bin/rm  -R /Library/PrivilegedHelperTools/com.microsoft.* &>/dev/null
	/bin/rm  -R /var/db/receipts/com.microsoft.office.* &>/dev/null
	OFFICERECEIPTS=$(pkgutil --pkgs=com.microsoft.office.*)
	for ARECEIPT in $OFFICERECEIPTS
	do
		pkgutil --forget $ARECEIPT
	done
exit 0