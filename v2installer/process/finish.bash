# Part of Alaterm, version 2.
# Routine for creating the launch command, then finish.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi


# Alaterm uses pacman package manager. Termux uses pkg, based on Debian tools.
# If the Alaterm user attempts to use pkg, dpkg, apt, or related programs,
# then a friendly message will be issued:
create_fakeExecutables() {
	install_template "pkg.bash" "755"
	cd "$alatermTop/usr/local/scripts"
	cp pkg dpkg && cp pkg aptitude && cp pkg apt
	for f in deb convert divert query split trigger ; do
		cp dpkg "dpkg-$f"
	done
	for f in cache config get key mark ; do
		cp apt "apt-$f"
	done
} # End create_fakeExecutables.

# This function creates or edits Termux $HOME/.bashrc.
# Previous references to Alaterm are removed, to avoid duplication.
modify_termuxBashrc() {
	tbrc="$HOME/.bashrc" # Termux home, not Alaterm home.
	touch "$tbrc" # If not already there, create it.
	grep "launch.*laterm" "$tbrc" >/dev/null 2>&1
	if [ "$?" -ne 0 ] ; then
		echo "To launch Alaterm, command:  alaterm" >> "$tbrc"
	fi
} # End modify_termuxBashrc.


# Sequence of actions.
# Install help:
cp -r -f "$here/help-alaterm" "$alatermTop/usr/local/"
mkdir -p "$alatermTop/system"
mkdir -p "$alatermTop/vendor"
mkdir -p "$alatermTop/odm"
# Intercept Alaterm calls to inappropriate Termux executables:
create_fakeExecutables
# Let user know when Alaterm logs out, and returns to Termux:
install_template "bash.bash_logout.bash"
# Install launchCommand, and copy to Termux:
install_template "launchcommand.bash" "755"
cp "$alatermTop/usr/local/scripts/$launchCommand" "$PREFIX/bin/"
# Prevent Alaterm from launching a second instance of itself:
install_template "fake-launch.bash" "755"
# Let Termux know that Alaterm is installed:
modify_termuxBashrc
# Make backup copy of original status file:
cp "$alatermTop/status" "$alatermTop/status.orig"

# Extras:
install_template "TeXworks.conf"
mkdir -p "$alatermTop/home/.config/dbus" # Needed for some applications.
install_template "dbus-programs.bash" "755"
install_template "dbus-programs.hook"
mkdir -p "$alatermTop/home/.local/share/applications" # Custom *.desktop.
install_template "mimeapps-list.bash" "755"
install_template "mimeapps-list.hook"
install_template "autoremove.bash" "755"
install_template "ban-menu-items.bash" "755"
install_template "ban-menu-items.hook"
install_template "compile-libde265.bash" "755"
install_template "compile-libmad.bash" "755"
install_template "compile-libmpeg2.bash" "755"

# Add info to Termux welcome:
touch "$termuxHome/.bashrc"
sed -i '/launch.*laterm/d' "$termuxHome/.bashrc" 2>/dev/null
echo "echo \"To launch Alaterm, command:  alaterm\"" >> "$termuxHome/.bashrc"

# Finalize:
echo "createdLaunch=yes" >> "$alatermTop/status"
echo "let scriptRevision=$thisRevision" >> "$alatermTop/status"
echo "completedInstall=yes" >> "$alatermTop/status"
echo "## Installation complete." >> "$alatermTop/status"
echo "## Anything after this is an update." >> "$alatermTop/status"
##
