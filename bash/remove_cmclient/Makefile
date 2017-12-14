include /usr/local/share/luggage/luggage.make

TITLE=UninstallSCCM
NAME=UninstallCMClient
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PACKAGE_ID=${REVERSE_DOMAIN}.${NAME}
REVERSE_DOMAIN=com.domain
PACKAGE_VERSION=1.0
PAYLOAD= \
	pack-script-postinstall \
	pack-domain-uninstall-sccm
DEST="/private/tmp/unsccm"
ASSET1="CMUninstall"

pack-domain-uninstall-sccm:
	@sudo mkdir -p ${WORK_D}${DEST}
	@sudo ${CP} ${ASSET1} ${WORK_D}${DEST}/
	@sudo chmod -R 755 ${WORK_D}${DEST}
	@sudo chown -R root:wheel ${WORK_D}${DEST}/*
