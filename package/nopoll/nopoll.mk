################################################################################
#
# nopoll 
#
################################################################################

NOPOLL_VERSION = 0.4.2
NOPOLL_MINOR_VERSION=b297
NOPOLL_SOURCE = nopoll-$(NOPOLL_VERSION).$(NOPOLL_MINOR_VERSION).tar.gz
NOPOLL_SITE = http://www.aspl.es/nopoll/downloads
NOPOLL_DEPENDENCIES = host-pkgconf openssl
NOPOLL_INSTALL_STAGING = YES
NOPOLL_AUTORECONF = YES
NOPOLL_LICENSE = LGPLv2.1
NOPOLL_LICENSE_FILES = COPYING 

# nopoll connection uses attr symbols from -lpthread
NOPOLL_CONF_ENV += nopoll_cv_pthreads_lib="-lpthread"

#Removing trailing whitespace character from the PC file
define NOPOLL_REMOVE_TRAILING_WHITESPACE_CHAR
    $(SED) 's/@ /@/g' $(@D)/nopoll.pc.in
endef
NOPOLL_POST_EXTRACT_HOOKS += NOPOLL_REMOVE_TRAILING_WHITESPACE_CHAR

$(eval $(autotools-package))
