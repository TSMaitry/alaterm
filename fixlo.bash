#!/bin/bash
# Fix for LibreOffice /proc not mounted.
# Do not use this unless you need it.
# Must be re-run whenever LibreOffice is updated.
# Run from Termux:  bash fixlo
# Do not run from within alaterm.

if [ "$THOME" != "" ] ; then
	echo "This script does not run from within alaterm."
	exit 1
fi
mkdir -p "$alatermTop/prod"
chmod 755 "$alatermTop/prod"
cd "$alatermTop/prod"
echo "1" > version
chmod 755 version
cd "$alatermTop/usr/lib/libreoffice/program"
sed -i 's/\/proc/\/prod/g' oosplash

exit

