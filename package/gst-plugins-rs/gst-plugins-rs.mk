################################################################################
#
# gst-plugins-rs
#
################################################################################

GST_PLUGINS_RS_VERSION = 0.8
GST_PLUGINS_RS_SOURCE = gst-plugins-rs-$(GST_PLUGINS_RS_VERSION).tar.gz
GST_PLUGINS_RS_SITE = https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/$(GST_PLUGINS_RS_VERSION)
GST_PLUGINS_RS_LICENSE = LICENSE-MPL-2.0
GST_PLUGINS_RS_LICENSE_FILES = LICENSE-MPL-2.0
GST_PLUGINS_RS_CARGO_BUILD_OPTS = --package gst-plugin-spotify

define GST_PLUGINS_RS_BUILD_CMDS
  cd $(@D) && \
    $(TARGET_MAKE_ENV) \
    $(TARGET_CONFIGURE_OPTS) \
    $(PKG_CARGO_ENV) \
    $(GST_PLUGINS_RS_CARGO_ENV) \
    $(HOST_DIR)/bin/cargo cbuild --target=$(RUSTC_TARGET_NAME) \
    --release \
    --manifest-path audio/spotify/Cargo.toml \
    $(GST_PLUGINS_RS_CARGO_BUILD_OPTS)
endef

define GST_PLUGINS_RS_INSTALL_TARGET_CMDS
  cd $(@D) && \
  $(TARGET_MAKE_ENV) \
    $(TARGET_CONFIGURE_OPTS) \
    $(PKG_CARGO_ENV) \
    $(GST_PLUGINS_RS_CARGO_ENV) \
    $(HOST_DIR)/bin/cargo cinstall --target=$(RUSTC_TARGET_NAME) \
      --release --manifest-path audio/spotify/Cargo.toml \
      --libdir $(TARGET_DIR)/usr/lib/ \
      --lib \
    $(GST_PLUGINS_RS_CARGO_BUILD_OPTS)
endef

$(eval $(cargo-package))
