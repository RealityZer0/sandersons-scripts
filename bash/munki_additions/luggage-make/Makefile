#==========#
# ABOUT THIS SCRIPT:
# NAME: MunkiAdditions
# SYNOPSIS:
#==========#
# HISTORY:
# Version 3.4.3
# Created by Heig Gregorian
# Revised by Scott Anderson
# Revision Date 10/13/16
#==========#
# ADDITIONAL INFO:
#==========#

include /usr/local/share/luggage/luggage.make

TITLE_PREFIX=Munki\ Additions
NAME_PREFIX=Munki_Additions
MUNKI_PKG_NAME=MunkiAdditions
PACKAGE_NAME=${NAME}-${PACKAGE_VERSION}
PACKAGE_ID=${REVERSE_DOMAIN}.${NAME}
REVERSE_DOMAIN=com.domain
PACKAGE_VERSION=1.0
MUNKI_DIR="/usr/local/munki"
TYPE=FULL

# BASE Package:
#ifeq (${TYPE},BASE)
#	PAYLOAD=\
			pack-ma-preinstall-base \
			pack-munki-additions
#	TITLE=${TITLE_PREFIX}\ \(BASE\)
#	NAME=${NAME_PREFIX}_BASE
#endif

# FULL Package:
ifeq (${TYPE},FULL)
	PAYLOAD=\
			pack-script-preinstall \
			pack-script-postinstall \
			pack-munki-additions
	TITLE=${TITLE_PREFIX}\ \(FULL\)
	NAME=${NAME_PREFIX}_FULL
	USE_PKGBUILD=0
endif

pack-munki-additions: l_usr_local
	@sudo mkdir -p ${WORK_D}/${MUNKI_DIR}
	@sudo ${CP} -R ../usr/local/munki/* ${WORK_D}/${MUNKI_DIR}/
	@sudo chown -R root:wheel ${WORK_D}/${MUNKI_DIR}
	@sudo chmod -R 755 ${WORK_D}/${MUNKI_DIR}

#pack-ma-preinstall-base:
#	@sudo ${INSTALL} -m 755 ./preinstall_base ${SCRIPT_D}/preinstall

#pack-ma-preinstall-full:
#	@sudo ${INSTALL} -m 755 ./preinstall ${SCRIPT_D}/preinstall

help::
	@-echo
	@-echo "Additional information:"
	@-echo
	@-echo "TYPE variable may be specified to alter output package:"
	@-echo "Available types:"
	@-echo "	BASE	pre/postinstall scripts will not be included"
	@-echo "	FULL	pre/postinstall are included"
	@-echo
	@-echo "Usage Examples:"
	@-echo "	make dmg TYPE=BASE"
	@-echo "	make dmg TYPE=FULL"
	@-echo
	@-echo "Note: If TYPE is not specified FULL is assumed."
	@-echo

info::
	@-echo TITLE=${TITLE}
	@-echo MUNKI_PKG_NAME=${MUNKI_PKG_NAME}
	@-echo PACKAGE_ID=${PACKAGE_ID}
	@-echo PACKAGE_VERSION=${PACKAGE_VERSION}
	@-echo PACKAGE_NAME=${PACKAGE_NAME}
	@-echo TYPE=${TYPE}
	@-echo PAYLOAD=${PAYLOAD}
