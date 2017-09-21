include /usr/local/share/luggage/luggage.make

TITLE=CCDesktopAppBundle
NAME=CCloudDesktopAppBundle
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PACKAGE_ID=${REVERSE_DOMAIN}.${NAME}
REVERSE_DOMAIN=com.domain
PACKAGE_VERSION=1.0
PAYLOAD= \
	pack-script-postinstall \
	pack-ccda-installer \
DEST="/private/tmp/ccda"
ASSET1="CreativeCloudDesktopApp_XXXXX.pkg"
ASSET2="AdobeCreativeCloud-info.pdf"

pack-ccda-installer:
		@sudo mkdir -p ${WORK_D}${DEST}
		@sudo ${CP} -R ${ASSET1} ${WORK_D}${DEST}/
		@sudo ${CP} ${ASSET2} ${WORK_D}${DEST}/
		@sudo chmod -R 755 ${WORK_D}${DEST}
		@sudo chown -R root:wheel ${WORK_D}${DEST}/*
