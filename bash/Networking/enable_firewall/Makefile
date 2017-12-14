include /usr/local/share/luggage/luggage.make

TITLE=Enable\ Firewall
NAME=enablefirewall
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PACKAGE_ID=${REVERSE_DOMAIN}.${NAME}
REVERSE_DOMAIN=com.domain
PACKAGE_VERSION=1.0
PAYLOAD= \
	pack-script-postinstall \
	pack-enable-firewall
DEST="/private/tmp/enalf"
ASSET1="com.domain.enable-alf.plist"
ASSET2="enable-alf.sh"

pack-domain-enable-firewall:
	@sudo mkdir -p ${WORK_D}${DEST}
	@sudo ${CP} ${ASSET1} ${WORK_D}${DEST}/
	@sudo ${CP} ${ASSET2} ${WORK_D}${DEST}/
	@sudo chmod -R 755 ${WORK_D}${DEST}
	@sudo chown -R root:wheel ${WORK_D}${DEST}/*
	@sudo chmod -R 644 ${WORK_D}${DEST}/${ASSET1}
