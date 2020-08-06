# Part of the alaterm project, https://github.com/cargocultprog/alaterm/
# This file is: https://raw.githubusercontent.com/cargocultprog/alaterm/master/08-alaterm.bash
# Updated for version 1.6.0.

echo "$(caller)" | grep -F 00-alaterm.bash >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
echo "Script 08-alaterm.bash is not stand-alone."
echo "It must be sourced in sequence from 00-alaterm.bash."
echo "Exit." ; exit 1
fi


##############################################################################
## INSTALLER PART 08. Create launch script, and finish.
##############################################################################


start_launchCommand() {
cat << EOC > "$launchCommand" # No hyphen. Unquoted marker. Single gt.
#!/bin/bash
# This is the launch command for alaterm, Arch Linux ARM in Termux.
# It is placed in Termux $PREFIX/bin by the installer script.
# A backup copy is placed in the top level of alaterm.
# If necessary, copy the backup copy into Termux $PREFIX/bin.
#
source "$alatermTop/status"
EOC
}

finish_launchCommand() { # Added to above.
cat << 'EOC' >> "$launchCommand" # No hyphen. Quoted marker. Double gt.
hash proot >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo -e "\e[1;91mPROBLEM.\e[0m Termux does not have proot installed. Cannot launch alaterm."
	echo -e "Use Termux pkg to install proot, then try again.\n"
	exit 1
fi
# It is possible to install different vncservers in Termux, and in alaterm.
# If Termux vncserver is running when alaterm is launched, there will be conflict.
# This checks for active Termux vncserver:
hash vncserver >/dev/null 2>&1 # Refers to Termux vncserver.
if [ "$?" -eq 0 ] ; then
	vncserver -list | grep :[1234567890] >/dev/null 2>&1
	if [ "$?" -eq 0 ] ; then # Termux vncserver is on.
		echo -e "\e[1;91mPROBLEM.\e[0m Termux has its own vncserver active."
		echo "Alaterm cannot launch due to conflict."
		echo "When this script exits to Termux, run this command:"
		echo -e "\e[1;33mvncserver -list\e[0m"
		echo -e "Display number is \e[1;33m:1\e[0m or \e[1;33m:2\e[0m or whatever."
		echo "Then run this command, using the display number instead of :1 if necessary:"
		echo -e "\e[1;33mvncserver -kill :1\e[0m"
		echo "If the server is successfully killed, then you can run alaterm."
		echo -e "This script will now exit.\n" ; exit 1
	fi
fi
#
# The alatermstatnow routine, in versions prior to 1.4.4, has been removed.
#
# The proot string tells how alaterm is configured within its proot confinement.
# Actually, it is not much confinement, since alaterm can access most outside files,
# and can even run a few Termux executables.
prsUser="proot --kill-on-exit --link2symlink -v -1 -0 -r $alatermTop " # zero
prsUser+="-b /proc -b /system -b /sys -b /dev -b /data -b /vendor "
[ ! -r /dev/ashmem ] && prsUser+="-b $alatermTop/tmp:/dev/ashmem " # Probably OK as-is.
[ ! -r /dev/shm ] && prsUser+="-b $alatermTop/tmp:/dev/shm " # Probably does not exist, but is expected.
[ ! -r /proc/stat ] && prsUser+="-b $alatermTop/var/binds/fakePS:/proc/stat "
[ ! -r /proc/version ] && prsUser+="-b $alatermTop/var/binds/fakePV:/proc/version "
[ -d /sdcard ] && prsUser+="-b /sdcard "
[ -d /storage ] && prsUser+="-b /storage "
prsUser+="-b /proc/self/fd/0:/dev/stdin -b /proc/self/fd/1:/dev/stdout -b /proc/self/fd/2:/dev/stderr "
prsUser+="-w /home "
prsUser+="/usr/bin/env - TERM=$TERM HOME=/home "
prsUser+="/bin/su -l user"
# The Termux LD_PRELOAD interferes with proot:
unset LD_PRELOAD
# Now to launch alaterm:
eval "exec $prsUser"
# The above command continues to run, until logout of alaterm.
##
EOC
}

create_fakeLaunch() { # In alaterm /usr/bin.
fakelc="# File "
fakelc+="$alatermTop/usr/bin/$launchCommand."
cat << EOC > "$launchCommand" # No hyphen. Unquoted marker.
#!/bin/bash
$fakelc
# Fake launch script.
echo -e "\e[33mYou cannot launch alaterm from within alaterm.\e[0m"
##
EOC
}

restore_launchCommand() { # In Termux home. Deals with situation where $PREFIX is deleted and renewed.
	grep alaterm_installer .bashrc >/dev/null 2>&1
	if [ "$?" -ne 0 ] ; then
		echo "export alatermTop=$alatermTop # By_alaterm_installer." >> .bashrc
		echo "export launchCommand=$launchCommand # By_alaterm_installer." >> .bashrc
	fi
	if [ ! -f "$PREFIX/bin/$launchCommand" ] ; then
		grep alaterm_installer .bashrc >/dev/null 2>&1
		if [ "$?" -ne 0 ] ; then
			cp "$alatermTop/$launchCommand" "$PREFIX/bin" 2>/dev/null
			if [ "$?" -ne 0 ] ; then
				echo "WARNING. Did not find backup copy of alaterm launch command."
				echo "To restore alaterm, re-run:  bash 00-alaterm.bash install"
				echo "Whether that takes a minute, or much longer, is unclear."
			else
				echo -e "\e[1;92mRestoring alaterm to renewed Termux."
				echo -e "Only takes a minute. May require Termux update...\e[0m"
				sleep 3
				needem=""
				hash proot >/dev/null 2>&1
				[ "$?" -ne 0 ] && needem=proot
				hash wget >/dev/null 2>&1
				[ "$?" -ne 0 ] && needem+=" wget"
				if [ "$needem" != "" ] ; then
					pkg update
					pkg install $needem # No quotes.
				fi
			fi
			echo -e "\e[1;92mDONE.\e[0m You may now launch alaterm. Command: $launchCommand"
		fi
	fi
}

create_fixDbuslaunch() { # In /usr/local/scripts. Thanks to bbs.archlinux.org q. 240261 answer by V1del.
cat << EOC > fixdbuslaunch # No hyphen. Unquoted marker.
#!/bin/bash
# Script /usr/local/scripts/fixdbuslaunch created by installer.
# Solves problem where dbus does not autolaunch.
if [ -f /usr/share/applications/org.gnome.gedit.desktop ] ; then
	cp /usr/share/applications/org.gnome.gedit.desktop /home/.local/share/applications/
	cd /home/.local/share/applications
	sed -i 's/Exec=gedit/Exec=dbus-run-session gedit/g' org.gnome.gedit.desktop
else
	rm -f /home/.local/share/applications/org.gnome.gedit.desktop
fi
if [ -f /usr/share/applications/org.gnome.font-viewer.desktop ] ; then
	cp /usr/share/applications/org.gnome.font-viewer.desktop /home/.local/share/applications/
	cd /home/.local/share/applications
	sed -i 's/Exec=gnome-font-viewer/Exec=dbus-run-session gnome-font-viewer/g' org.gnome.font-viewer.desktop
else
	rm -f /home/.local/share/applications/org.gnome.font-viewer.desktop
fi
EOC
}

create_fixdbuslaunchHook() { # In /etc/pacman.d/hooks.
cat << EOC > fixdbuslaunch.hook # No hyphen. Unquoted marker.
[Trigger]
Type = File
Operation = Install
Operation = Upgrade
Operation = Remove
Target = *

[Action]
Description = Fixing dbus launchers...
When = PostTransaction
Exec = /usr/local/scripts/fixdbuslaunch
EOC
}

create_fakeFunctions() { # In /usr/local/scripts.
	echo "#!/bin/bash" > dpkg
	echo "echo \"In alaterm, use pacman for package management.\"" >> dpkg
	chmod 750 dpkg
	cp dpkg dpkg-deb
	cp dpkg dpkg-convert
	cp dpkg dpkg-divert
	cp dpkg dpkg-query
	cp dpkg dpkg-split
	cp dpkg dpkg-trigger
	cp dpkg pkg
	cp dpkg aptitude
	cp dpkg apt
	cp dpkg apt-cache
	cp dpkg apt-config
	cp dpkg apt-get
	cp dpkg apt-key
	cp dpkg apt-mark
}


fix_etcBashBashrc() { # In /etc.
	sed -i '/alias makepkg/d' bash.bashrc 2>/dev/null
	sed -i '/alias fakeroot/d' bash.bashrc 2>/dev/null
	sed -e -i '/nofakeroot()/,+2d' bash.bashrc 2>/dev/null
	sed -i '/Ensure that.*and Termux/d' bash.bashrc
	sed -i '/PATH.*local\/scripts/d' bash.bashrc
	sed -i '/PATH.*HOME\/bin/d' bash.bashrc
	sed -i 's/-ge 2010/-le 2009/' bash.bashrc 2>/dev/null
	tlt="If using Internet installer of TUG TeXLive" # Added in v. 1.2.8.
	sed -i "/$tlt/,+16d" "$alatermTop/etc/bash.bashrc" # Removed v. 1.2.8-b.
	# In v. 1.4.4:
	grep /status bash.bashrc >/dev/null 2>&1
	[ "$?" -ne 0 ] && echo "source /status" >> bash.bashrc
}

fix_etcProfile() { #in /etc.
	grep "home correction" profile >/dev/null 2>&1
	if [ "$?" -ne 0 ] ;then
		echo "# Added home correction:" >> profile
		echo "PATH=\$HOME/bin:\$PATH" >> profile
		echo "export PATH" >> profile
		echo "##" >> profile
	fi
}

add_banMenuItems() { # In /usr/local/scripts.
	grep qdbusviewer ban-menu-items >/dev/null 2>&1
	[ "$?" -ne 0 ] && add_bans_one
}

add_bans_one() { # Modifies /usr/local/scripts/ban-menu-items.
cat << 'EOC' >> "ban-menu-items" # No hyphen, quoted marker, double gt.
# Some programs also install Qt, which has its own menu items that do not work.
declare -A nomenu1
nomenu1[assistant]="Qt Assistant"
nomenu1[designer]="Qt Designer"
nomenu1[linguist]="Qt Linguist"
nomenu1[qdbusviewer]="Qt dbus Viewer"
for i in "${!nomenu1[@]}" ; do
	if [ -f "/usr/share/applications/$i.desktop" ] ; then
		echo "[Desktop Entry]" > "$lsa/$i.desktop"
		echo "Name=${nomenu1[$i]}" >> "$lsa/$i.desktop"
		echo "Type=Application" >> "$lsa/$i.desktop"
		echo "NoDisplay=true" >> "$lsa/$i.desktop"
	elif [ -f "$lsa/$i.desktop" ] ; then
		rm -f "$lsa/$i.desktop"
	fi
done
##
EOC
}

copy_help() {
	mkdir -p "$alatermTop/usr/local/scripts/help"
	cp "$hereiam/help-alaterm-0.html" "$alatermTop/usr/local/scripts/help"
	cp "$hereiam/help-alaterm-1.html" "$alatermTop/usr/local/scripts/help"
	cp "$hereiam/help-alaterm-2.html" "$alatermTop/usr/local/scripts/help"
	cp "$hereiam/help-alaterm-3.html" "$alatermTop/usr/local/scripts/help"
} # End copy_help.

fix_exports() {
	cd "$alatermTop"
	grep PROBLEM= status >/dev/null 2>&1
	if [ "$?" -eq 0 ] ; then
		sed -i 's/^PROBLEM/export PROBLEM/' status
	else
		echo "export PROBLEM=\"\e[1;91mPROBLEM.\e[0m\"" >> status
	fi
	grep WARNING= status >/dev/null 2>&1
	if [ "$?" -eq 0 ] ; then
		sed -i 's/^WARNING/export WARNING/' status
	else
		echo "export WARNING=\"\e[1;91mWARNING.\e[0m\"" >> status
	fi
	sed -i 's/^termuxTop/export termuxTop/' status
	sed -i 's/^termuxPrefix/export termuxPrefix/' status
	grep TUSR= status >/dev/null 2>&1
	if [ "$?" -ne 0 ] ; then
		echo "export TUSR=\"$termuxPrefix\"" >> status
	fi
	sed -i 's/^termuxHome/export termuxHome/' status
	if [ "$?" -ne 0 ] ; then
		echo "export THOME=\"$termuxHome\"" >> status
	fi
	sed -i 's/^termuxLdPreload/export termuxLdPreload/' status
	sed -i 's/^alatermTop/export alatermTop/' status
	sed -i 's/^launchCommand/export launchCommand/' status
	sed -i 's/^CPUABI/export CPUABI/' status
	sed -i 's/^userLocale/export userLocale/' status
}

if [ "$nextPart" -ge 8 ] ; then # This part repeats, if necessary.
	cd "$hereiam"
	source fixexst-scripts.bash
	cd "$alatermTop/usr/local/scripts"
	rm -f pkg-config # Fix in v. 1.2.2.
	create_fakeFunctions
	create_compileLibde265
	add_banMenuItems # v. 1.2.8.
	chmod 750 compile-libde265
	create_compileLibmad
	chmod 750 compile-libmad
	create_compileLibmpeg2
	chmod 750 compile-libmpeg2
	create_autoremove
	chmod 750 autoremove
	create_fixDbuslaunch
	chmod 750 fixdbuslaunch
	cd "$alatermTop/etc"
	sed -i '/.*autokill.*/d' bash.bash_logout
	fix_etcBashBashrc # v. 1.2.2.
	fix_etcProfile # v. 1.2.2.
	cd "$alatermTop/usr/local/help"
	copy_help # v. 1.4.4.
	cd "$alatermTop/etc/pacman.d/hooks"
	create_fixdbuslaunchHook
	rm -f fixgedit.hook
	cd "$alatermTop"
	fix_exports
	start_launchCommand
	finish_launchCommand
	chmod 750 "$launchCommand"
	cp "$launchCommand" "$PREFIX/bin"
	grep alaterm ~/.bashrc >/dev/null 2>&1 # In Termux home.
	if [ "$?" -ne 0 ] ; then
		echo -e "echo \"To launch alaterm, command:  $launchCommand\"\n" >> ~/.bashrc
	fi
	cd "$alatermTop/home"
	mkdir -p .config/dbus
	cd "$alatermTop/usr/bin"
	create_fakeLaunch
	chmod 750 "$launchCommand" # Not the real one.
	cd "$HOME" # Termux home
	restore_launchCommand
	cd "$hereiam"
	echo -e "\n\e[1;92mDONE. To launch alaterm, command:  $launchCommand\e[0m\n"
	let nextPart=9
	if [ "$scriptRevision" != "$thisRevision" ] ; then
		echo "let scriptRevision=$thisRevision" >> "$alatermTop/status"
	fi
	if [ "$nextPart" -ne 9 ] ; then
		echo "let nextPart=9" >> "$alatermTop/status" # Fake marker. There is no Part 09.
	fi
fi



