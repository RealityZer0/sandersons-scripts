include /usr/local/share/luggage/luggage.make
PACKAGE_VERSION=1.0
TITLE=RemoveSierra
PACKAGE_NAME=${TITLE}-${PACKAGE_VERSION}
REVERSE_DOMAIN=com.domain
PAYLOAD=\
	pack-script-postinstall \
	pack-Library-LaunchDaemons \
	pack-remSierra-usr \
	pack-noSierra-usr \

pack-Library-LaunchDaemons:l_Library_LaunchDaemons
	@sudo ${CP} -R com.domain.removeSierra.plist ${WORK_D}/Library/LaunchDaemons/
	@sudo chmod 644 ${WORK_D}/Library/LaunchDaemons/com.domain.removeSierra.plist
	@sudo chown root:wheel ${WORK_D}/Library/LaunchDaemons/com.domain.removeSierra.plist

pack-remSierra-usr: l_usr_local
	@sudo mkdir -p ${WORK_D}/usr/local/scripts/noSierra
	@sudo ${CP} -R removeSierra ${WORK_D}/usr/local/scripts/noSierra
	@sudo chmod 755 ${WORK_D}/usr/local/scripts/noSierra/removeSierra
	@sudo chown root:wheel ${WORK_D}/usr/local/scripts/noSierra/removeSierra

pack-noSierra-usr: l_usr_local
	@sudo mkdir -p ${WORK_D}/usr/local/scripts/noSierra
	@sudo ${CP} -R noSierra.app ${WORK_D}/usr/local/scripts/noSierra
	@sudo chmod 755 ${WORK_D}/usr/local/scripts/noSierra/noSierra.app
	@sudo chown root:wheel ${WORK_D}/usr/local/scripts/noSierra/noSierra.app
