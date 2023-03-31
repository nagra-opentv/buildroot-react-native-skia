#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

for arg in "$@"
do
	case "${arg}" in
		--add-miniuart-bt-overlay)
		if ! grep -qE '^dtoverlay=' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			echo "Adding 'dtoverlay=miniuart-bt' to config.txt (fixes ttyAMA0 serial console)."
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# fixes rpi (3B, 3B+, 3A+, 4B and Zero W) ttyAMA0 serial console
dtoverlay=miniuart-bt
__EOF__
		fi
		;;
		--aarch64)
		# Run a 64bits kernel (armv8)
		sed -e '/^kernel=/s,=.*,=Image,' -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		if ! grep -qE '^arm_64bit=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# enable 64bits support
arm_64bit=1
__EOF__
		fi
		;;
		--gpu_mem_256=*|--gpu_mem_512=*|--gpu_mem_1024=*)
		# Set GPU memory
		gpu_mem="${arg:2}"
		sed -e "/^${gpu_mem%=*}=/s,=.*,=${gpu_mem##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		;;
    --fix-alsa)
    if ! grep -qE '^dtparam=audio' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
    echo "Adding 'dtparam=audio=on' to config.txt."
      cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Fix ALSA
dtparam=audio=on
__EOF__
    fi
    ;;
    --i2c)
	  if ! grep -qE '^dtparam=i2c_arm=on' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
		echo "Adding 'i2c' functionality to config.txt."
      cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable i2c functionality
dtparam=i2c_arm=on
dtparam=i2c1=on
__EOF__
    fi
    ;;
    --add-vc4-fkms-v3d-overlay)
		if ! grep -qE '^dtoverlay=vc4-fkms-v3d' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			echo "Adding 'dtoverlay=vc4-fkms-v3d' to config.txt (Load VC4 driver with KMS, creates /dev/dri/card0)."
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Load VC4 driver with KMS, creates /dev/dri/card0
dtoverlay=vc4-fkms-v3d
__EOF__
		fi
    ;;
	esac

done

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
