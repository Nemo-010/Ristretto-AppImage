#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm ristretto doxygen rust

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building glycin-ng with HEIF support..."
echo "---------------------------------------------------------------"
git clone -b heif-support https://github.com/Nemo-010/glycin-ng.git ./glycin-ng && (
	cd ./glycin-ng
	cargo build --release -p glycin-ng-c
	cargo build --release -p glycin-ng-libglycin-shim
)

cp -f ./glycin-ng/target/release/libglycin_ng.so /usr/lib/libglycin_ng.so
cp -f ./glycin-ng/target/release/libglycin_2.so /usr/lib/libglycin-2.so.0
chmod +x /usr/lib/libglycin_ng.so /usr/lib/libglycin-2.so.0

# Comment this out if you need an AUR package
# make-aur-package 

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
