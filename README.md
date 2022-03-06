Buildroot overlay for React Native Skia
======================================================

This repository contains documentation, tools, and build recipes to create
[React Native Skia](https://github.com/nagra-opentv/react-native-skia) for Embedded devices, with directory ready to use with
`BR2_EXTERNAL`.

Building
--------

Chose the appropriate “defconfig” for the target device (see list of [included
configurations](#included-configurations) below) with [Buildroot-2021.02.9](https://buildroot.org/downloads/buildroot-2021.02.9.tar.gz) and follow the instructons below

```sh
wget https://buildroot.org/downloads/buildroot-2021.02.9.tar.gz
tar xf buildroot-2021.02.9.tar.gz
cd buildroot-2021.02.9
mkdir -p /opt/workshop/external/foss_dl
make BR2_EXTERNAL='<path to buildroot-rns>' BR2_DL_DIR=/opt/workshop/external/foss_dl raspberrypi3_rns_defconfig
make BR2_EXTERNAL='<path to buildroot-rns>' BR2_DL_DIR=/opt/workshop/external/foss_dl
```

This will download the needed sources, configure Buildroot, compile RNS, and
store images in `output/` subdirectory.


Flashing & Booting
------------------

You can use [etcher](https://etcher.io) to flash the `output/images/sdcard.img` to sdcard.
Then insert the flashed sdcard to RPI3 slot and boot it.

Running React Native app
------------------------

This setup already provides two test app bundle located at /opt/rns-samples/.
First login using root user with password 'root'. Then you can run apps using following command.

```sh
ReactSkiaApp /opt/rns-samples/simpleView/SampleViewApp.bundle
ReactSkiaApp /opt/rns-samples/simpleViewTimer/SampleViewApp.bundle
```
To build more test apps you can refer to [Build Code Section from RNS](https://github.com/react-native-skia/react-native-skia#build-instructions)


Included Configurations
-----------------------

- `raspberrypi3_rns_defconfig`: Produces an 384MB image file at
  `output/images/sdcard.img` for the Raspberry Pi3 with RPI-UserLand. The image
  should be written raw to the sdcard, using a tool like `dd` or
  [etcher](https://etcher.io)

Documentation
-------------

- [Buildroot's `BR2_EXTERNAL`](https://buildroot.org/downloads/manual/manual.html#outside-br-custom).

Known Issues
------------
- On RPI-3 getting `getGLError 0x505` for bigger sample apps, even when GPU memory confugured to 512 MB.
