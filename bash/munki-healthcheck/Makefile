include /usr/local/share/luggage/luggage.make
PACKAGE_VERSION=1.0
TITLE=munkihealthcheck
PACKAGE_NAME=${TITLE}-${PACKAGE_VERSION}
REVERSE_DOMAIN=com.domain
PAYLOAD=\
	pack-script-preinstall \
	pack-script-postinstall \
	pack-Library-LaunchDaemons \
	pack-munkihc-usr \

pack-Library-LaunchDaemons:l_Library_LaunchDaemons
	@sudo ${CP} -R com.domain.munki-healthcheck.plist ${WORK_D}/Library/LaunchDaemons/
	@sudo chmod 644 ${WORK_D}/Library/LaunchDaemons/com.domain.munki-healthcheck.plist
	@sudo chown root:wheel ${WORK_D}/Library/LaunchDaemons/com.domain.munki-healthcheck.plist

pack-munkihc-usr: l_usr_local
	@sudo mkdir -p ${WORK_D}/usr/local/scripts/
	@sudo ${CP} -R munkihc ${WORK_D}/usr/local/scripts/
	@sudo chmod 755 ${WORK_D}/usr/local/scripts/munkihc
	@sudo chown root:wheel ${WORK_D}/usr/local/scripts/munkihc
