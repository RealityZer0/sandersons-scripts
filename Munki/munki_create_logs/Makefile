include /usr/local/share/luggage/luggage.make

TITLE=Create\ Munki\ Logs
NAME=CreateMunkiLogs
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PACKAGE_ID=${REVERSE_DOMAIN}.${NAME}
REVERSE_DOMAIN=com.domain
PACKAGE_VERSION=1.0
DEST="/private/tmp/munkilogs"
ASSET="CreateMunkiLogs"

PAYLOAD= \
	pack-script-postinstall \
	pack-yp-munkilogs

pack-munkilogs:
	@sudo mkdir -p ${WORK_D}${DEST}
	@sudo ${CP} ${ASSET} ${WORK_D}${DEST}/
	@sudo chmod -R 644 ${WORK_D}${DEST}
	@sudo chown -R root:wheel ${WORK_D}${DEST}/*
	@sudo chmod -R 755 ${WORK_D}${DEST}/*
