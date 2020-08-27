#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/compile-libmpeg2
# Use of compile-libmpeg2 is optional. Only if you need it.
#
# Purpose of this script:
# The libmpeg2 distributed by Arch Linux ARM, and installable to Alaterm,
# calls for executable stack. That is an Android security policy violation.
# So, libmpeg2 and any program invoking it will not work in Alaterm.
# This script compiles an acceptable version of libmpeg2 from source code.
# The compiled version does not call for executable stack, so it works.
#
# Since libmpeg2 is long-established, it is unlikely that a newer version
# will fix the problem or improve its function. But in case an update
# installs a problematic libmpeg2, you can re-install this compiled version
# simply by re-running this script. It will find the pre-compiled files
# and re-install them, as long as you do not delete ~/.source/libmpeg2.
# Or, you can choose to download fresh code and re-compile.
#
# How to know if libmpeg2, or anything, has a problem with executable stack:
# Install the pax-utils program. Then command:  scanelf -lpqe
# It returns a list of problem files. More info:
# https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart
#
locate_installable() {
	if [ -f ~/.source/libmpeg2/libmpeg2/libmpeg2.la ] ; then # This is not the only installable file.
		echo "Found installable files from previous build of libmpeg2."
		printf "Do you wish to re-install them, without re-build? [Y|n] : " ; read readvar
		case "$readvar" in
			n*|N* ) ask_continue ;;
			* ) printf "Just a moment... "
				cd ~/.source/libmpeg2
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
	printf "Download libmpeg2 source code, build, and install it? [Y|n] : " ; read readvar
	case "$readvar" in
		n*|N* ) echo "At your request, script will now exit." ; exit 0 ;;
		* ) mkdir -p ~/.source
			if [ -d ~/.source/libmpeg2 ] ; then
				cd ~/.source/libmpeg2
				chmod -R 0777 .git >/dev/null 2>&1
				mv .git gone >/dev/null 2>&1
				rm -r -f gone
				cd ~/.source
				rm -r -f libmpeg2
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
	echo -e "\e[1;92mDownloading source code for libmpeg2...\e[0m"
	mkdir ~/.source && cd ~/.source
	git clone https://github.com/cisco-open-source/libmpeg2.git
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Download failed during git clone libmpeg2."
		echo "Wait a minute, then re-run this script to try again."
		exit 1
	fi
	cd ~/.source/libmpeg2
	echo "Patching libmpeg2 source code..."
	# Many thanks to contributors at https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart for this:
	if [ -f libmpeg2/motion_comp_arm_s.S ] ; then
		grep -F GNU-stack libmpeg2/motion_comp_arm_s.S >/dev/null 2>&1
		if [ "$?" -ne 0 ] ; then
			echo "#if defined(__linux__) && defined(__ELF__)" >> libmpeg2/motion_comp_arm_s.S
			echo ".section .note.GNU-stack,\"\",%progbits" >> libmpeg2/motion_comp_arm_s.S
			echo "#endif" >> libmpeg2/motion_comp_arm_s.S
		fi
	fi
	configure_libmpeg2
}
configure_libmpeg2() {
	echo "Now configuring and compiling libmpeg2. Takes a few minutes..."
	./configure --prefix=/usr
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Configuring libmpeg2 failed."
		echo -e "Probably a missing package needs to be installed."
		echo -e "Look at the last few lines above this message."
		exit 1
	fi
	build_libmpeg2
}
build_libmpeg2() {
	echo -e "\e[1;92mBuilding libmpeg2 code...\e[0m"
	make
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Building libmpeg2 failed."
		echo -e "Look at the last few lines above."
		exit 1
	fi
	install_libmpeg2
}
install_libmpeg2() {
	echo -e "\e[1;92mInstalling...\e[0m"
	sudo make install
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Installing libmpeg2 failed."
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
