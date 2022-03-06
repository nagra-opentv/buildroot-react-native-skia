################################################################################
#
# WPEBackend-RDK
#
################################################################################

WPEBACKEND_RDK_VERSION = b4cde3824bbc779cc4c7f9f81aa5c489eb2e97c5 
WPEBACKEND_RDK_SITE = $(call github,nagra-opentv,WPEBackend-rdk,$(WPEBACKEND_RDK_VERSION))
WPEBACKEND_RDK_INSTALL_STAGING = YES
WPEBACKEND_RDK_DEPENDENCIES = libwpe libglib2

ifeq ($(BR2_PACKAGE_XKEYBOARD_CONFIG),y)
WPEBACKEND_RDK_DEPENDENCIES += xkeyboard-config
endif

# USE_BACKEND_BCM_RPI
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WPEBACKEND_RDK_DEPENDENCIES += rpi-userland libegl libinput
WPEBACKEND_RDK_CONF_OPTS += -DUSE_BACKEND_BCM_RPI=ON
endif

ifeq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_HAS_LIBEGL_WAYLAND),yy)
WPEBACKEND_RDK_DEPENDENCIES += wayland libxkbcommon
WPEBACKEND_RDK_CONF_OPTS += -DUSE_BACKEND_WAYLAND_EGL=ON -DUSE_KEY_INPUT_HANDLING_LINUX_INPUT=OFF
endif

$(eval $(cmake-package))
