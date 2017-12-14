include /usr/local/share/luggage/luggage.make

TITLE=Tree
NAME=Tree
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PACKAGE_ID=${REVERSE_DOMAIN}.${NAME}
REVERSE_DOMAIN=com.domain
PACKAGE_VERSION=1.0
PAYLOAD= \
	pack-script-postinstall \
	pack-domain-tree
DEST="/private/tmp/tree"
ASSET1="tree"

pack-domain-tree:
	@sudo mkdir -p ${WORK_D}${DEST}
	@sudo ${CP} ${ASSET1} ${WORK_D}${DEST}/
	@sudo chmod -R 755 ${WORK_D}${DEST}
	@sudo chown -R root:wheel ${WORK_D}${DEST}/*
	@sudo chmod -R 555 ${WORK_D}${DEST}/${ASSET1}
