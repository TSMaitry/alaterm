#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/default-resolution

# This is an ESSENTIAL feature of Alaterm. Do not delete this file.

showdrhelp() {
	echo "Usage:  default-resolution WxH"
	echo "where W and H are 3 to 4 digit numbers."
	echo "Installation default is  1280x800"
	echo "This routine changes the default LXDE Desktop resolution."
	echo "Change is not activated until next time Alaterm is launched."
	echo "If your desired default is on the LXDE Desktop Menu in"
	echo "Preferences > Monitor Settings, then use the Menu instead."
	echo "But if the desired setting is not listed, this command adds it."
}
dnuyou() {
	echo "Did not understand the argument. Try again."
	exit 1
}
oor() {
	echo "Value for width or height is out of range. Try again."
	exit 1
}
if [ "$#" -ne 1 ] || [[ ! "$1" =~ ^[1-9] ]] ; then
	showdrhelp ; exit 0
fi
wxh="$(echo $1 | sed 's/X/x/g')"
w="$(echo $wxh | sed 's/x.*//g')"
h="$(echo $wxh | sed 's/^.*x//g')"
w="$(expr $w + 0)"
[ "$?" -ne 0 ] && dnuyou
h="$(expr $h + 0)"
[ "$?" -ne 0 ] && dnuyou
if [ "$w" -lt 480 ] || [ "$w" -gt 9600 ] ; then oor ; fi
if [ "$h" -lt 480 ] || [ "$h" -gt 9600 ] ; then oor ; fi
sed -i "s/^geometry.*/geometry=$wxh/g" ~/.vnc/config
echo "Default screen will be $wxh when you re-launch Alaterm."
##
