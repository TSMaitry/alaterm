#!/bin/bash
# Alaterm:file=$alatermTop/getlxde-launch.bash
# This TEMPORARY file is created during Alaterm installation.
# Then it is automatically discarded after use.
# If it was not discarded, you may remove it.

# Earlier, Alaterm created a new Arch user with sudo privileges.
# It also created a temporary /home/.bashrc file, with detailed instructions
# for installing new packages, to create the LXDE Desktop.
# This script logs into Arch as user, and performs the temporary .bashrc.
# When it completes, it logs out, then discards this file.

source PARSE$alatermTop/status

prsTempUser="--kill-on-exit --link2symlink -v -1 -0 -r $alatermTop"
prsTempUser+=" -b /proc -b /system -b /sys -b /dev -b /data"
[ ! -r /dev/ashmem ] && prsTempUser+=" -b $alatermTop/tmp:/dev/ashmem"
[ ! -r /dev/shm ] && prsTempUser+=" -b $alatermTop/tmp:/dev/shm"
if [ ! -r /proc/stat ] ; then
	prsTempUser+=" -b $alatermTop/var/binds/dummyPS:/proc/stat"
fi
if [ ! -r /proc/version ] ; then
	prsTempUser+=" -b $alatermTop/var/binds/dummyPV:/proc/version"
fi
[ -d /sdcard ] && prsTempUser+=" -b /sdcard"
prsTempUser+=" -b /proc/self/fd/0:/dev/stdin"
prsTempUser+=" -b /proc/self/fd/1:/dev/stdout"
prsTempUser+=" -b /proc/self/fd/2:/dev/stderr"
prsTempUser+=" -w /home"
prsTempUser+=" /usr/bin/env - TERM=$TERM HOME=/home"
prsTempUser+=" /bin/su -l user"
#
unset LD_PRELOAD # Termux LD_PRELOAD cannot be used in proot.
proot $prsTempUser # No quotes.
#
##
