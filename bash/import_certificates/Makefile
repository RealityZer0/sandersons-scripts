include /usr/local/share/luggage/luggage.make

TITLE=OSX\ Certificates
NAME=OSXCertificates
REVERSE_DOMAIN=com.domain
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PAYLOAD= \
	pack-script-postinstall \
	pack-cert-installer
PACKAGE_VERSION=1.3
DEST="/private/tmp/certs"
ASSET1="certs.bz2"

pack-cert-installer:
	@sudo mkdir -p ${WORK_D}${DEST}
	@sudo ${CP} ${ASSET1} ${WORK_D}${DEST}/
	@sudo chmod -R 755 ${WORK_D}${DEST}
	@sudo chown -R root:wheel ${WORK_D}${DEST}/*
