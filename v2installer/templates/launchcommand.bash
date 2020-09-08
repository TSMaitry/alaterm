#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/$launchCommand
# File /usr/local/scripts/PARSE$launchCommand
# Also copied to Termux $PREFIX/bin/.

# This is the Alaterm launch command.
# It cannot be run from within Alaterm.
# If you ever delete it from Termux $PREFIX/bin/, then copy it to there.

echo "$PWD" | grep files >/dev/null 2>&1 # Part of Android path to Termux.
if [ "$?" -ne 0 ] ; then
	echo "This command cannot be launched within Alaterm."
	echo "You may only launch it from Termux, outside of Alaterm."
	exit 1
fi

source PARSE$alatermTop/status

hash proot >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo -e "$PROBLEM Termux does not have proot installed."
	echo "Cannot launch Alaterm now."
	echo "Use Termux pkg to install proot, then try again."
	exit 1
fi
# It is possible to install vncservers both in Termux and in Alaterm.
# They conflict if both are in use at the same time.
# This checks for active Termux vncserver:
hash vncserver >/dev/null 2>&1 # Refers to Termux vncserver.
if [ "$?" -eq 0 ] ; then
	vncserver -list | grep :[1234567890] >/dev/null 2>&1
	if [ "$?" -eq 0 ] ; then # Termux vncserver is on.
		echo -e "$PROBLEM Termux vncserver is active."
		echo "Alaterm cannot launch due to conflict."
		echo "When this script exits to Termux, command:"
		echo -e "\e[1;33mvncserver -list\e[0m"
		printf "Display number is \e[1;33m:1\e[0m or "
		printf "\e[1;33m:2\e[0m or whatever.\n"
		echo "Then command, using actual display number:"
		echo -e "\e[1;33mvncserver -kill :1\e[0m"
		echo "If server killed, then you can run Alaterm."
		exit 1
	fi
fi

# The proot string defines Alaterm paths within its confinement.
# Actually, Alaterm can access most outside files,
# and can even run a few Termux executables.
prsUser="--kill-on-exit --link2symlink -v -1 -0 -r $alatermTop"
prsUser+=" -b /proc -b /system -b /dev -b /data "
# /dev/ashmem or /dev/shm may be called by some programs,
# but they may not exist or be accessible in Alaterm. Bind /tmp instead:
[ ! -r /dev/ashmem ] && prsUser+=" -b $alatermTop/tmp:/dev/ashmem"
[ ! -r /dev/shm ] && prsUser+=" -b $alatermTop/tmp:/dev/shm"
[ -d /sys ] && prsUser+=" -b /sys"
[ -d /vendor ] && prsUser+=" -b /vendor"
[ -d /odm ] && prsuser+=" -b /odm"
[ -d /product ] && prsuser+=" -b /product"
# Many parts of Android /proc ae inacessible and cannot be mounted in Alaterm.
# Bind fake information instead, which fools many programs:
if [ ! -r /proc/stat ] ; then
	prsUser+=" -b $alatermTop/var/binds/dummyPS:/proc/stat"
fi
if [ ! -r /proc/version ] ;then
	prsUser+=" -b $alatermTop/var/binds/dummyPV:/proc/version"
fi
[ -d /sdcard ] && prsUser+=" -b /sdcard" # Built-in.
[ -d /storage ] && prsUser+=" -b /storage" # Removable.
prsUser+=" -b /proc/self/fd/0:/dev/stdin"
prsUser+=" -b /proc/self/fd/1:/dev/stdout"
prsUser+=" -b /proc/self/fd/2:/dev/stderr"
# Starts Alaterm in its /home directory:
prsUser+=" -w /home"
# Keeops pre-defined environment, with these corrections if necessary:
prsUser+=" /usr/bin/env - TERM=$TERM HOME=/home"
# Switches into the default non-root user:
prsUser+=" /bin/su -l user"
# The Termux LD_PRELOAD interferes with proot:
unset LD_PRELOAD
# Now to launch Alaterm:
proot $prsUser # No quotes.
# The above continues to run, until logout of Alaterm.
##
