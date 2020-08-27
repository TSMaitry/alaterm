#!/bin/bash
# Alaterm:file=$alatermTop/prelim-launch.bash
# This TEMPORARY file is created during Alaterm installation.
# If it was not automatically discarded, then you may remove it now.

# Prior to this, Arch Linux ARM was unpacked to Alaterm directory.
# A temporary /root/.bashrc file was created, with detailed instructions
# for updating Arch, removing useless packages, installing sudo,
# and creating a new user with sudo privileges.
# This script logs in as Arch root, not Android root,
# and performs the instructions in /root/.bashrc.
# Then it will automatically log out, and discard this file.

source PARSE$alatermTop/status

prsTempRoot="--kill-on-exit --link2symlink -v -1 -0 -r $alatermTop"
prsTempRoot+=" -b /proc -b /dev -b /sys -b /data"
[ ! -r /dev/ashmem ] && prsTempRoot+=" -b $alatermTop/tmp:/dev/ashmem"
[ ! -r /dev/shm ] && prsTempRoot+=" -b $alatermTop/tmp:/dev/shm"
if [ ! -r /proc/stat ] ; then
	prsTempRoot+=" -b $alatermTop/var/binds/dummyPS:/proc/stat"
fi
if [ ! -r /proc/version ] ; then
	prsTempRoot+=" -b $alatermTop/var/binds/dummyPV:/proc/version"
fi
prsTempRoot+=" -w /root"
prsTempRoot+=" /usr/bin/env - TERM=$TERM HOME=/root TMPDIR=/tmp"
prsTempRoot+=" /bin/sh -l"
#
unset LD_PRELOAD # Termux LD_PRELOAD cannot be used in proot.
proot $prsTempRoot # No quotes.
#
##
