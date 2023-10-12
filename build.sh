#!/bin/bash
set -e

if [ ! -f build/build.sh ]; then
echo "Downloading toolkit"
git clone --depth=1 https://github.com/phhusson/vendor_hardware_overlay.git
( cd vendor_hardware_overlay && git checkout origin/pie build && mv build .. )
fi

echo "Building overlay APK"
( cd build && ./build.sh ../MulchWebView/Android.mk )

## vendor/overlay (A12 and before)

echo "Building flashable package (vendor/overlay)"
mkdir -p build/.temp
mkdir -p build/.temp/META-INF/com/google/android
cp update-binary build/.temp/META-INF/com/google/android
echo "# Dummy file; update-binary is a shell script." > build/.temp/META-INF/com/google/android/updater-script
mkdir -p build/.temp/system/addon.d
cp 99-mulch-webview.sh build/.temp/system/addon.d
mkdir -p build/.temp/vendor/overlay
cp build/treble-overlay-mulch-webview.apk build/.temp/vendor/overlay
( cd build/.temp && zip -r - . > ../MulchSystemWebViewOverlay-vendor.zip . ) &> /dev/null
rm -r build/.temp

echo "Building Magisk module (vendor/overlay)"
mkdir -p build/.temp
mkdir -p build/.temp/META-INF/com/google/android
cp module_installer.sh build/.temp/META-INF/com/google/android/update-binary
echo "#MAGISK" > build/.temp/META-INF/com/google/android/updater-script
mkdir -p build/.temp/system/vendor/overlay
cp build/treble-overlay-mulch-webview.apk build/.temp/system/vendor/overlay
cp module.prop build/.temp/
( cd build/.temp && zip -r - . > ../MulchSystemWebViewMagisk-vendor.zip . ) &> /dev/null
rm -r build/.temp

## product/overlay (A13 and onwards)

echo "Building flashable package (product/overlay)"
mkdir -p build/.temp
mkdir -p build/.temp/META-INF/com/google/android
cp update-binary build/.temp/META-INF/com/google/android
echo "# Dummy file; update-binary is a shell script." > build/.temp/META-INF/com/google/android/updater-script
mkdir -p build/.temp/system/addon.d
cp 99-mulch-webview.sh build/.temp/system/addon.d
mkdir -p build/.temp/product/overlay
cp build/treble-overlay-mulch-webview.apk build/.temp/product/overlay
( cd build/.temp && zip -r - . > ../MulchSystemWebViewOverlay-product.zip . ) &> /dev/null
rm -r build/.temp

echo "Building Magisk module (product/overlay)"
mkdir -p build/.temp
mkdir -p build/.temp/META-INF/com/google/android
cp module_installer.sh build/.temp/META-INF/com/google/android/update-binary
echo "#MAGISK" > build/.temp/META-INF/com/google/android/updater-script
mkdir -p build/.temp/system/product/overlay
cp build/treble-overlay-mulch-webview.apk build/.temp/system/product/overlay
cp module.prop build/.temp/
( cd build/.temp && zip -r - . > ../MulchSystemWebViewMagisk-product.zip . ) &> /dev/null
rm -r build/.temp
