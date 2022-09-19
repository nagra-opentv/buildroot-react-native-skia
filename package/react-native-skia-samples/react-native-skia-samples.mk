############################################################
#
# React Native Skia Samples
#
#############################################################

REACT_NATIVE_SKIA_SAMPLES_VERSION = 0.1-beta
REACT_NATIVE_SKIA_SAMPLES_SITE = $(BR2_EXTERNAL_RNS_PATH)/src/react-native-skia-samples
REACT_NATIVE_SKIA_SAMPLES_SITE_METHOD = local
REACT_NATIVE_SKIA_SAMPLES_INSTALL_STAGING = NO

REACT_NATIVE_SKIA_DEPENDENCIES = react-native-skia

# configure command
define REACT_NATIVE_SKIA_SAMPLES_CONFIGURE_CMDS
	(echo "Nothing to configure for pre-bundled samples";)
endef

# build command
define REACT_NATIVE_SKIA_SAMPLES_BUILD_CMDS
	(echo "Nothing to build for pre-bundled samples";)
endef

# install target command
define REACT_NATIVE_SKIA_SAMPLES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/opt/rns-samples/
	(echo "Installing Pre-bundled React Native Skia Samples Apps..." ; \
	rsync --recursive $(@D)/simpleView $(TARGET_DIR)/opt/rns-samples/; \
	rsync --recursive $(@D)/simpleTimer $(TARGET_DIR)/opt/rns-samples/; \
	rsync --recursive $(@D)/simpleNavigation $(TARGET_DIR)/opt/rns-samples/; \
	rsync --recursive $(@D)/simpleDemo1 $(TARGET_DIR)/opt/rns-samples/; \
	rsync --recursive $(@D)/simpleDemoScroll $(TARGET_DIR)/opt/rns-samples/; \
	rsync --recursive $(@D)/simplePoster $(TARGET_DIR)/opt/rns-samples/;)
endef	

$(eval $(generic-package))
