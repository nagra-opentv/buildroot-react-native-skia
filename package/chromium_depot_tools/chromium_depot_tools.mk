#############################################################
#
# chromium depot tools
#
#############################################################

CHROMIUM_DEPOT_TOOLS_VERSION = 0bfbd890c3e2f3aa734119507d14162248409664
CHROMIUM_DEPOT_TOOLS_SITE = https://chromium.googlesource.com/chromium/tools/depot_tools
CHROMIUM_DEPOT_TOOLS_SITE_METHOD = git

#Pre compiled Clang-11 for linux X64 this will be faster than downloading and building clang
CHROMIUM_DEPOT_TOOLS_CLANG_VERSION = n356902-4e813bbd-1
CHROMIUM_DEPOT_TOOLS_EXTRA_DOWNLOADS += https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/clang-$(CHROMIUM_DEPOT_TOOLS_CLANG_VERSION).tgz
CHROMIUM_DEPOT_TOOLS_CLANG_BASE_PATH=$(CHROMIUM_DEPOT_TOOLS_BUILDDIR)clang

# post-extract hooks
define CHROMIUM_DEPOT_TOOLS_GET_CLANG
	(echo ">>> Extracting clang to $(CHROMIUM_DEPOT_TOOLS_CLANG_BASE_PATH)...."; \
	if [ ! -d "$(CHROMIUM_DEPOT_TOOLS_CLANG_BASE_PATH)" ]; then \
		mkdir -p $(CHROMIUM_DEPOT_TOOLS_CLANG_BASE_PATH) && tar xf $(CHROMIUM_DEPOT_TOOLS_DL_DIR)/clang-$(CHROMIUM_DEPOT_TOOLS_CLANG_VERSION).tgz -C $(CHROMIUM_DEPOT_TOOLS_CLANG_BASE_PATH);\
	fi)
endef
CHROMIUM_DEPOT_TOOLS_POST_EXTRACT_HOOKS += CHROMIUM_DEPOT_TOOLS_GET_CLANG

$(eval $(generic-package))

