#!/bin/bash
# Fix for LibreOffice /proc not mounted.
# DO NOT USE THIS UNLESS YOU NEED IT.
# If LibreOffice fails to launch,
# and terminal reports error with /proc not mounted,
# first try exiting alaterm, then re-launch it.
# If that did not work, then try this script.
# It must be re-run whenever LibreOffice is updated.
# Run from Termux:  bash fixlo.bash
# Do not run from within alaterm.

if [ "$THOME" != "" ] ; then # THOME is defined within alaterm.
	echo "This script does not run from within alaterm."
	echo "Logout of alaterm, then run script from Termux."
	exit 1
fi
mkdir -p "$alatermTop/prod"
chmod 750 "$alatermTop/prod"
cd "$alatermTop/prod"
echo "1" > version
chmod 750 version
cd "$alatermTop/usr/lib/libreoffice/program"
sed -i 's/\/proc/\/prod/g' oosplash

exit 0

