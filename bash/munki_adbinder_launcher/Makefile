include /usr/local/share/luggage/luggage.make

TITLE=MacadminTerminal
NAME=MacadminTerminal
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PACKAGE_ID=${REVERSE_DOMAIN}.${NAME}
REVERSE_DOMAIN=com.domain
PACKAGE_VERSION=1.0
PAYLOAD= \
	pack-script-postinstall \
	pack-domain-madmin-term
DEST="/private/tmp/madminterm"
ASSET1="MacadminTerminal.mobileconfig"

pack-domain-madmin-term:
		@sudo mkdir -p ${WORK_D}${DEST}
		@sudo ${CP} ${ASSET1} ${WORK_D}${DEST}/
		@sudo chmod -R 755 ${WORK_D}${DEST}
		@sudo chown -R macadmin:staff ${WORK_D}${DEST}/*
		@sudo chmod -R 644 ${WORK_D}${DEST}/${ASSET1}
