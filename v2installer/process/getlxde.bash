# Part of Alaterm, version 2.
# Routine for installing the LXDE Desktop.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi


# Procedure for this part:
echo -e "$INFO Creating the LXDE graphical desktop..."
touch "$alatermTop/home/.Xauthority"
install_template "home.vnc-config.conf"
install_template "home.vnc-xstartup.bash" "755"
# Instructions for downloading and installing the LXDE Desktop are in here:
install_template "getlxde-profile.bash" # As /etc/profile.
touch "$alatermTop/home/.Xauthority" # Need this file, even if empty.
# Create temporary user launch command:
install_template "getlxde-launch.bash" "755"
# Now do it:
bash "$alatermTop/getlxde-launch.bash"
tempv="$(grep configuredVnc $alatermTop/status 2>/dev/null)"
if [ "$tempv" = "" ] ; then # Failed temp-userlaunch.bash.
	echo -e "$PROBLEM Failed to configure vncserver."
	rm -f "$alatermTop/getlxde-launch.bash"
	exit 1
else
	echo -e "$INFO Completed LXDE setup."
fi
rm -f "$alatermTop/getlxde-launch.bash"
# Install a variety of files:
[ -f "$alatermTop/usr/bin/trash-put" ] && install_template "readme-trash.md"
install_template "profile.bash" # The real one.
install_template "root.bash_profile.bash"
install_template "root.bashrc.bash"
install_template "home.bash_profile.bash"
install_template "home.bashrc.bash"
install_template "home.Xdefaults.conf" # Nicer xterm than original.
install_template "desktop-items-0.conf" # For pcmanfm.
install_template "panel.conf" # LXDE control panel.
install_template "menu.xml" # Contents of LXDE Menu.
install_template "bookmarks.conf"
# Not all file managers respect comments in bookmarks:
sed -i '/file=/d' "$alatermTop/home/.config/gtk-3.0/bookmarks"
install_template "default-resolution.bash" "755"
install_template "home.vnc-config.conf"
install_template "home.vnc-xstartup.bash" "755"
install_template "lxde-rc.xml"
install_template "nanorc.conf"
echo -e "$INFO Installed and configured LXDE Desktop."
echo "configuredDesktop=yes" >> "$alatermTop/status"
sleep .2
##
