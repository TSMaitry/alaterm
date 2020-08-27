#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/compile-libde265
# Script compile-libde265, created by Alaterm installer.

# Use of compile-libde265 is optional. Only if you need it.

# Purpose of this script:
# The libde265 distributed by Arch Linux ARM, and installable to Alaterm,
# calls for executable stack. That is an Android security policy violation.
# So, libde265 and any program invoking it will not work in Alaterm.
# Those programs involve encoding or decoding the heic/heif image format.
# This script compiles an acceptable version of libde265 from source code.
# The compiled version does not call for executable stack, so it works.
#
# Since the h265 format is relatively recent, and libde265 is contemporary,
# there may be updates to libde265 source code as time progresses.
# After compiling and installing the current source code, the installable
# files are retained, as long as you do not delete ~/.source/libde265.
# If a distributed package update installs a non-working libde265,
# you can re-install these compiled files by running this script again.
# Then you do not have to re-compile. But you also will have the choice
# to disregard the existing installables, and re-compile with fresh code.
#
# How to know if libde265, or anything, has a problem with executable stack:
# Install the pax-utils program. Then command:  scanelf -lpqe
# It returns a list of problem files. More info:
# https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart
##

check_heif() {
	gdk-pixbuf-query-loaders 2>/dev/null | grep image/heif >/dev/null 2>&1
	if [ "$?" -eq 0 ] ; then
		echo "It looks like heif/heic support works OK."
		echo "You may not need to build libde265."
		printf "Build/reinstall the code, or eXit? [b|X] : " ; read readvar
		case "$readvar" in
			b*|B* ) locate_installable ;;
			* ) echo "You did not request build. Exit." ; exit 0 ;;
		esac
	else
		locate_installable
	fi
}
locate_installable() {
	if [ -f ~/.source/libde265/tools/yuv-distortion ] ; then # Not the only installable file.
		echo "Found installable files from previous build."
		printf "Do you wish to re-install them, without re-build? [Y|n] : " ; read readvar
		case "$readvar" in
			n*|N* ) ask_continue ;;
			* ) printf "Just a moment... "
				cd ~/.source/libde265
				sudo make install >/dev/null 2>&1
				if [ "$?" -eq 0 ] ; then
					echo "DONE." ; exit 0
				else
					echo -e "$PROBLEM Could not complete re-install."
					ask_continue
				fi ;;
		esac
	else
		ask_continue
	fi
}
ask_continue() {
	printf "Download libde265 source code, build, and install it? [Y|n] : " ; read readvar
	case "$readvar" in
		n*|N* ) echo "At your request, script will now exit." ; exit 0 ;;
		* ) mkdir -p ~/.source
			if [ -d ~/.source/libde265 ] ; then
				cd ~/.source/libde265
				chmod -R 0777 .git >/dev/null 2>&1
				mv .git gone >/dev/null 2>&1
				rm -r -f gone
				cd ~/.source
				rm -r -f libde265
			fi ;;
	esac
	setup_compiler
}
setup_compiler() {
	echo -e "\e[1;92mChecking for compiler system and dependencies...\e[0m"
	sudo pacman -Syu --noconfirm
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Download failed during pacman update."
		echo "Wait a minute, then re-run this script to try again."
		exit 1
	fi
	sudo pacman -S --noconfirm --needed base-devel git pax-utils
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM New package download failed."
		echo "Wait a minute, then re-run this script to try again."
		exit 1
	fi
	echo -e "\e[1;92mIf you saw a number of warnings above, just ignore them.\e[0m"
	get_sourcecode
}
get_sourcecode() {
	echo -e "\e[1;92mInstalling support programs...\e[0m"
	sudo pacman -S --noconfirm --needed gdk-pixbuf2 sdl imagemagick
	echo -e "\e[1;92mDownloading source code for libde265...\e[0m"
	mkdir -p ~/.source && cd ~/.source
	git clone https://github.com/strukturag/libde265.git
	configure_libde265
}
scriptSignal() { # Run on various interrupts. Ensures wakelock is removed.
	termux-wake-unlock 2>/dev/null
	echo -e "\e[1;33mWARNING.\e[0m Signal ${?} received."
	exit 1
}
scriptExit() {
	termux-wake-unlock 2>/dev/null
	echo -e "This script will now exit.\n"
}
configure_libde265() {
	# Ensure that wakelock is removed if script is interrupted:
	trap scriptSignal HUP INT TERM QUIT
	trap scriptExit EXIT
	termux-wake-lock 2>/dev/null
	sleep 1
	cd ~/.source/libde265
	echo -e "\e[1;92mConfiguring libde265 code. Takes about 3 minutes...\e[0m"
	./autogen.sh
	if [ "$?" -ne 0 ] ; then
		echo "Failure during autogen. Inspect above lines to identify the problem"
		exit 1
	fi
	./configure --disable-sherlock265 --disable-arm --prefix=/usr
	if [ "$?" -ne 0 ] ; then
		echo "Failure during configure. Inspect above lines to identify the problem"
		exit 1
	fi
	build_libde265
}
build_libde265() {
	echo -e "\e[1;92mBuilding libde265 code. Takes about 22 minutes...\e[0m"
	make 2>builderror | grep -F make[
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Building libde265 failed."
		echo -e "Error messages are in file ~/libde265/builderror."
		echo -e "Look at the last few lines of that file."
		exit 1
	fi
	install_libde265
}
install_libde265() {
	echo -e "\e[1;92mInstalling...\e[0m"
	sudo make install
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Installing libde265 failed."
		echo -e "Look at the last few lines above."
		exit 1
	fi
	rm -r -f ~/.source/libde265/builderror
	echo -e "\e[1;92mDONE.\e[0m"
	echo "For best results, logout of Alaterm, then re-launch Alaterm."
	echo "A copy of the compiled, installable files has been retained."
	echo "If you ever need to re-install them, run compile-libde265 again."
	echo "The script will ask whether to re-install or compile fresh."
}
check_heif
##
