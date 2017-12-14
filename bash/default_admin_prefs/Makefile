include /usr/local/share/luggage/luggage.make

TITLE=DefaultAdminPrefs
NAME=DefaultAdminPrefs
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PACKAGE_ID=${REVERSE_DOMAIN}.${NAME}
REVERSE_DOMAIN=com.domain
PACKAGE_VERSION=1.0
PAYLOAD= \
	pack-script-postinstall \
	pack-domain-madmin-prefs
DEST="/private/tmp/madminprefs"
ASSET1="com.apple.dock.plist"
ASSET2="com.apple.Terminal.plist"
ASSET3="com.apple.finder.plist"
ASSET4="desktoppicture.db"
ASSET5="Wallpaper.jpg"

pack-domain-madmin-prefs:
	@sudo mkdir -p ${WORK_D}${DEST}
	@sudo ${CP} ${ASSET1} ${WORK_D}${DEST}/
	@sudo ${CP} ${ASSET2} ${WORK_D}${DEST}/
	@sudo ${CP} ${ASSET3} ${WORK_D}${DEST}/
	@sudo ${CP} ${ASSET4} ${WORK_D}${DEST}/
	@sudo ${CP} ${ASSET5} ${WORK_D}${DEST}/
	@sudo chmod -R 755 ${WORK_D}${DEST}
	@sudo chown -R admin:admin ${WORK_D}${DEST}/*
	@sudo chmod -R 600 ${WORK_D}${DEST}/${ASSET1}
	@sudo chmod -R 600 ${WORK_D}${DEST}/${ASSET2}
	@sudo chmod -R 600 ${WORK_D}${DEST}/${ASSET3}
	@sudo chmod -R 644 ${WORK_D}${DEST}/${ASSET4}
	@sudo chmod -R 644 ${WORK_D}${DEST}/${ASSET5}
