#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/compile-libmad
# Use of compile-libmad is optional. Only if you need it.
#
# Purpose of this script:
# The libmad distributed by Arch Linux ARM, and installable to Alaterm,
# calls for executable stack. That is an Android security policy violation.
# So, libmad and any program invoking it will not work in Alaterm.
# This script compiles an acceptable version of libmad from source code.
# The compiled version does not call for executable stack, so it works.
#
# Since libmad is long-established, it is unlikely that a newer version
# will fix the problem or improve its function. But in case an update
# installs a problematic libmad, you can re-install this compiled version
# simply by re-running this script. It will find the pre-compiled files
# and re-install them, as long as you do not delete ~/.source/libmad.
# Or, you can choose to download fresh code and re-compile.
#
# How to know if libmad, or anything, has a problem with executable stack:
# Install the pax-utils program. Then command:  scanelf -lpqe
# It returns a list of problem files. More info:
# https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart
#
locate_installable() {
	if [ -f ~/.source/libmad/libmad.la ] && [ -f ~/.source/libmad/mad.h ] ; then
		echo "Found installable files from previous build."
		printf "Do you wish to re-install them, without re-build? [Y|n] : " ; read readvar
		case "$readvar" in
			n*|N* ) ask_continue ;;
			* ) printf "Just a moment... "
				cd ~/.source/libmad
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
	printf "Download libmad source code, build, and install it? [Y|n] : " ; read readvar
	case "$readvar" in
		n*|N* ) echo "At your request, script will now exit." ; exit 0 ;;
		* ) mkdir -p ~/.source
			if [ -d ~/.source/libmad ] ; then
				cd ~/.source/libmad
				chmod -R 0777 .git >/dev/null 2>&1
				mv .git gone >/dev/null 2>&1
				rm -r -f gone
				cd ~/.source
				rm -r -f libmad
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
	echo -e "\e[1;92mDownloading source code for libmad...\e[0m"
	mkdir -p ~/.source && cd ~/.source
	git clone https://github.com/markjeee/libmad.git
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Download failed during git clone libmad."
		echo "Wait a minute, then re-run this script to try again."
		exit 1
	fi
	cd ~/.source/libmad
	echo "Patching libmad source code..."
	# Requests for obsolete compiler flag --fforce-mem must be removed:
	[ -f configure.ac ] && sed -i '/fforce-mem/d' configure.ac
	[ -f configure ] && sed -i '/fforce-mem/d' configure
	configure_libmad
}
configure_libmad() {
	echo "Now configuring and compiling libmad. Takes a few minutes..."
	./configure --disable-aso --prefix=/usr
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Configuring libmad failed."
		echo -e "Probably a missing package needs to be installed."
		echo -e "Look at the last few lines above this message."
		exit 1
	fi
	build_libmad
}
build_libmad() {
	echo -e "\e[1;92mBuilding libmad code...\e[0m"
	make
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Building libmad failed."
		echo -e "Look at the last few lines above."
		exit 1
	fi
	install_libmad
}
install_libmad() {
	echo -e "\e[1;92mInstalling...\e[0m"
	sudo make install
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Installing libmad failed."
		echo -e "Look at the last few lines above."
		exit 1
	fi
	echo -e "\e[1;92mDONE.\e[0m"
	echo "For best results, logout of Alaterm, then re-launch Alaterm."
	echo "A copy of the compiled, installable files has been retained."
	echo "If you ever need to re-install them, re-run this script."
	echo "The script will ask whether to re-install or compile fresh."
}
locate_installable
##
