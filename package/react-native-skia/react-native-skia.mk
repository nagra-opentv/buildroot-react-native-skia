############################################################
#
# React Native Skia
#
#############################################################

REACT_NATIVE_SKIA_VERSION = 5f050267d671cf20abb428ad9d8afa089c9c3cce
REACT_NATIVE_SKIA_SITE = $(call github,nagra-opentv,react-native-skia,$(REACT_NATIVE_SKIA_VERSION))

RNS_TP_GN_VER=git_revision:7d7e8deea36d126397bda2cf924682504271f0e1
RNS_TP_BORINGSSL_VER=430a7423039682e4bbc7b522e3b57b2c8dca5e3b
RNS_TP_SKIA_VER=m86
RNS_TP_LIBCXX_VER=d9040c75cfea5928c804ab7c235fed06a63f743a
RNS_TP_LIBCXXABI_VER=196ba1aaa8ac285d94f4ea8d9836390a45360533
RNS_TP_DOUBLE_CONVERSION_VER=1.1.6
RNS_TP_GLOG_VER=0.3.5
RNS_TP_FOLLY_VER=2b9b7144fdafcc7c78d09465449f1c3a72386ac5
RNS_TP_REACT_NATIVE_VER=e794cea72fb8c0d810e1c6afb14e6677e5cef30b

RNS_TP_LIBCXX_URL=https://chromium.googlesource.com/external/github.com/llvm/llvm-project

REACT_NATIVE_SKIA_EXTRA_DOWNLOADS += \
                                      https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/%2B/$(RNS_TP_GN_VER) \
                                      https://boringssl.googlesource.com/boringssl/%2Barchive/$(RNS_TP_BORINGSSL_VER).tar.gz\
                                      https://skia.googlesource.com/skia/%2Barchive/refs/heads/chrome/$(RNS_TP_SKIA_VER).tar.gz \
                                      $(RNS_TP_LIBCXX_URL)/libcxx.git/%2Barchive/$(RNS_TP_LIBCXX_VER).tar.gz \
                                      $(RNS_TP_LIBCXX_URL)/libcxxabi.git/%2Barchive/$(RNS_TP_LIBCXXABI_VER).tar.gz \
                                      $(call github,google,double-conversion,v$(RNS_TP_DOUBLE_CONVERSION_VER)).tar.gz \
                                      $(call github,google,glog,v$(RNS_TP_GLOG_VER)).tar.gz\
                                      $(call github,Kudo,folly,$(RNS_TP_FOLLY_VER)).tar.gz\
                                      $(call github,nagra-opentv,react-native-tvos,$(RNS_TP_REACT_NATIVE_VER)).tar.gz

REACT_NATIVE_SKIA_INSTALL_STAGING = YES

REACT_NATIVE_SKIA_DEPENDENCIES = chromium_depot_tools boost expat libpng jpeg-turbo icu webp freetype nopoll harfbuzz wpewebkit

##Select Architecture
ifeq ($(BR2_arm),y)
	REACT_NATIVE_SKIA_PLATFORM_ARCH = arm
else
	ifeq ($(BR2_mipsel),y)
		REACT_NATIVE_SKIA_PLATFORM_ARCH = mipsel
	else ifeq ($(BR2_mips64el),y)
		REACT_NATIVE_SKIA_PLATFORM_ARCH = mips64el
	else
		REACT_NATIVE_SKIA_PLATFORM_ARCH = $(BR2_ARCH)
	endif
endif

REACT_NATIVE_SKIA_CLANG_BASE_PATH=$(CHROMIUM_DEPOT_TOOLS_BUILDDIR)/clang

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD),y)
REACT_NATIVE_SKIA_BUILD_ENV = \
	GCC_TOOLCHAIN_PATH=$(HOST_DIR)/opt/ext-toolchain
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_PREINSTALLED),y)
REACT_NATIVE_SKIA_BUILD_ENV = \
  GCC_TOOLCHAIN_PATH=$(BR2_TOOLCHAIN_EXTERNAL_PATH)
endif

REACT_NATIVE_SKIA_BUILD_ENV += \
	OTV_SYSROOT=$(STAGING_DIR) 

REACT_NATIVE_SKIA_GN_DEFINES = \
	target_cpu="$(REACT_NATIVE_SKIA_PLATFORM_ARCH)" \
	target_os="linux" \
	target_sysroot="$(STAGING_DIR)" \
	use_sysroot=false \
	is_clang=true \
	clang_base_path="$(REACT_NATIVE_SKIA_CLANG_BASE_PATH)" \
	use_lld=false \
	use_gold=false 

ifeq ($(BR2_SOFT_FLOAT), y)
REACT_NATIVE_SKIA_GN_DEFINES += \
  mips_float_abi="soft"
endif

# Configurations
REACT_NATIVE_SKIA_GN_DEFINES += \
	enable_vulkan=false \
	enable_skia_wuffs_gif=false

# Use thirdparty libraries from system for skia
REACT_NATIVE_SKIA_GN_DEFINES += \
	skia_use_system_libpng=true \
	skia_use_system_libjpeg_turbo=true \
	skia_use_system_icu=true \
	skia_use_system_libwebp=true \
	skia_use_system_expat=true \
	skia_use_system_nopoll=true \
	use_system_freetype=true \
	use_system_harfbuzz=true \
  use_system_libcurl=true 

# Debugging, profiling
REACT_NATIVE_SKIA_GN_DEFINES += \
	rns_enable_api_profiling = false

ifeq ($(BR2_PACKAGE_GLOG),y)
REACT_NATIVE_SKIA_DEPENDENCIES += glog 
REACT_NATIVE_SKIA_GN_DEFINES += use_system_glog=true
endif

# custom toolchain (TODO)
ifeq ($(BR2_PACKAGE_REACT_NATIVE_SKIA_USE_CUSTOM_TOOLCHAIN),y)
REACT_NATIVE_SKIA_BUILD_ENV += \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	NM="$(TARGET_NM)" \
	AR="$(TARGET_AR)" 

REACT_NATIVE_SKIA_GN_DEFINES += \
	custom_toolchain="//build/toolchain/linux/unbundle:default" \
	host_toolchain="//build/toolchain/linux/unbundle:host"
endif

##Select Graphics
#REACT_NATIVE_SKIA_EXTRA_FLAGS = "ENABLE_WINDOW_ID_PATCH"

REACT_NATIVE_SKIA_GN_DEFINES += \
	gl_use_glx=false \
  rns_enable_onscreen_keyboard = false \
  rns_enable_key_throttling = true \
  rns_enable_buffer_age_partial_updates = false \
	rns_enable_partial_updates = true

ifeq ($(BR2_PACKAGE_XORG7),y)
REACT_NATIVE_SKIA_GN_DEFINES += \
	gl_display_backend="x11"
  REACT_NATIVE_SKIA_DEPENDENCIES += xserver_xorg-server
else
REACT_NATIVE_SKIA_GN_DEFINES += \
	gl_display_backend="libwpe" \
	wpe_interface_version="1.0"
  REACT_NATIVE_SKIA_DEPENDENCIES += libwpe wpebackend-rdk
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)

  ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
    REACT_NATIVE_SKIA_DEPENDENCIES += rpi-userland
  else ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_ES),y)
    REACT_NATIVE_SKIA_DEPENDENCIES += mesa3d 
  endif

  REACT_NATIVE_SKIA_GN_DEFINES += \
    gl_use_opengl_es=true
else
  REACT_NATIVE_SKIA_GN_DEFINES += \
    gl_has_gpu=false \
    gl_use_opengl_es=false
endif

REACT_NATIVE_SKIA_EXTRA_FLAGS += "CA_CERTIFICATE=\"/etc/x509/CAfile.pem"\"

# Export extra compiler or CPP flags BUILD_CPPFLAGS env will be read by BUILD.gn file
REACT_NATIVE_SKIA_BUILD_ENV += 	BUILD_CPPFLAGS="${REACT_NATIVE_SKIA_EXTRA_FLAGS}"

# Disable debug build for optimizations 
REACT_NATIVE_SKIA_GN_DEFINES += is_debug=false
# Enable component build to generate shared libraries
REACT_NATIVE_SKIA_GN_DEFINES += is_component_build=true
# Debug or Release
REACT_NATIVE_SKIA_BUILD_TYPE = Debug

REACT_NATIVE_SKIA_BUILD_OUTPUT_DIR = out/$(REACT_NATIVE_SKIA_BUILD_TYPE)
REACT_NATIVE_SKIA_TARGET_NAME = ReactSkiaApp RnsPlatformPlugin

# EXtract thirdparty package. We may not need clang-format file now if required then add following line without # in REACT_NATIVE_SKIA_GET_THIRDPARTY
#PATH="$(PATH):$(CHROMIUM_DEPOT_TOOLS_BUILDDIR)" download_from_google_storage.py --no_resume --no_auth --bucket chromium-clang-format -s $(@D)/buildtools/linux64/clang-format.sha1; \

define REACT_NATIVE_SKIA_GET_THIRDPARTY
	(echo ">>> Extracting Thirdparty Libraries react-native, skia, folly, boringssl, libcxx, glog, double_conversion"; \
    unzip -j $(REACT_NATIVE_SKIA_DL_DIR)/$(RNS_TP_GN_VER) "gn" -d $(@D)/buildtools/linux64/ ; \
    mkdir -p $(@D)/third_party/skia && tar xf $(REACT_NATIVE_SKIA_DL_DIR)/$(RNS_TP_SKIA_VER).tar.gz -C $(@D)/third_party/skia; \
    mkdir -p $(@D)/third_party/boringssl/src && tar xf $(REACT_NATIVE_SKIA_DL_DIR)/$(RNS_TP_BORINGSSL_VER).tar.gz -C $(@D)/third_party/boringssl/src; \
    mkdir -p $(@D)/buildtools/third_party/libc++/trunk && tar xf $(REACT_NATIVE_SKIA_DL_DIR)/$(RNS_TP_LIBCXX_VER).tar.gz -C $(@D)/buildtools/third_party/libc++/trunk; \
    mkdir -p $(@D)/buildtools/third_party/libc++abi/trunk && tar xf $(REACT_NATIVE_SKIA_DL_DIR)/$(RNS_TP_LIBCXXABI_VER).tar.gz -C $(@D)/buildtools/third_party/libc++abi/trunk; \
    tar xf $(REACT_NATIVE_SKIA_DL_DIR)/$(RNS_TP_FOLLY_VER).tar.gz -C $(@D)/ && mv $(@D)/folly-$(RNS_TP_FOLLY_VER) $(@D)/folly; \
    tar xf $(REACT_NATIVE_SKIA_DL_DIR)/$(RNS_TP_REACT_NATIVE_VER).tar.gz -C $(@D)/ && mv $(@D)/react-native-tvos-$(RNS_TP_REACT_NATIVE_VER) $(@D)/react-native; \
    tar xf $(REACT_NATIVE_SKIA_DL_DIR)/v$(RNS_TP_GLOG_VER).tar.gz -C $(@D)/third_party && mv $(@D)/third_party/glog-$(RNS_TP_GLOG_VER) $(@D)/third_party/glog; \
    tar xf $(REACT_NATIVE_SKIA_DL_DIR)/v$(RNS_TP_DOUBLE_CONVERSION_VER).tar.gz -C $(@D)/third_party && mv $(@D)/third_party/double-conversion-$(RNS_TP_DOUBLE_CONVERSION_VER) $(@D)/third_party/double-conversion;) 
endef
REACT_NATIVE_SKIA_POST_EXTRACT_HOOKS += REACT_NATIVE_SKIA_GET_THIRDPARTY

ifneq ($(BR2_PACKAGE_RNS_APPS_DIR),)
define REACT_NATIVE_SKIA_APP_SYNC
    (if test -z "$(BR2_PACKAGE_RNS_APPS_DIR)" ; then \
      true ; \
     else \
      echo ">>> Syncing RN Applications !!!"; \
      mkdir -p $(@D)/ReactSkia/RnApps/;\
      rsync -ac $(BR2_PACKAGE_RNS_APPS_DIR)/RSkCodegenConf.json $(@D)/ReactSkia/RSkCodegenConf.json; \
      rsync -ac $(BR2_PACKAGE_RNS_APPS_DIR)/ $(@D)/ReactSkia/RnApps/; \
     fi);
endef

REACT_NATIVE_SKIA_PRE_CONFIGURE_HOOKS += REACT_NATIVE_SKIA_APP_SYNC
endif

define REACT_NATIVE_SKIA_GENERATE_BUILDGN
    (echo ">>> Generate External BUILD.GN !!!"; \
    python $(@D)/ReactSkia/scripts/buildgngen/RSkBuildGen.py $(@D)/out/Debug/gen/ $(@D)/ReactSkia/RSkCodegenConf.json $(@D);)
endef
REACT_NATIVE_SKIA_PRE_CONFIGURE_HOOKS += REACT_NATIVE_SKIA_GENERATE_BUILDGN

# configure command
define REACT_NATIVE_SKIA_CONFIGURE_CMDS
	(cd $(@D)/; \
	echo "$(CHROMIUM_DEPOT_TOOLS_BUILDDIR) $(REACT_NATIVE_SKIA_BUILD_ENV) gn gen $(REACT_NATIVE_SKIA_BUILD_OUTPUT_DIR)  --args='$(REACT_NATIVE_SKIA_GN_DEFINES)'"; \
	PATH="$(PATH):$(CHROMIUM_DEPOT_TOOLS_BUILDDIR)" $(REACT_NATIVE_SKIA_BUILD_ENV) gn gen $(REACT_NATIVE_SKIA_BUILD_OUTPUT_DIR) --args='$(REACT_NATIVE_SKIA_GN_DEFINES)')
endef

# build command
define REACT_NATIVE_SKIA_BUILD_CMDS
	(cd $(@D)/; \
	PATH="$(PATH):$(HOST_DIR)/bin:$(CHROMIUM_DEPOT_TOOLS_BUILDDIR)" $(REACT_NATIVE_SKIA_BUILD_ENV) ninja -C $(REACT_NATIVE_SKIA_BUILD_OUTPUT_DIR) $(REACT_NATIVE_SKIA_TARGET_NAME))
endef

# install target command
define REACT_NATIVE_SKIA_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin/assets/__react-native/Libraries/NewAppScreen/components
	(echo "Installing Third Party Libs..." ; \
	install -Dm755 $(@D)/out/Debug/lib{RnsPlatformPlugin,boringssl,c++,glog,skia,double-conversion}.so $(TARGET_DIR)/usr/lib/; \
	echo "Installing ReactSkiaApp..." ; \
	install -Dm755 $(@D)/out/Debug/ReactSkiaApp $(TARGET_DIR)/usr/bin/;)
endef	

$(eval $(generic-package))	
