# Alaterm:file=$alatermTop/home/.bash_profile
# File /home/.bash_profile, created by Alaterm installer.

# Normally, this file is not customized by user. Use ~/.bashrc instead.

# Alaterm uses BASH shell only.
# Version 2 does not use /etc/bash.bashrc.
# This file is read immediately after /etc/profile, at user login.
# It gets variables stored in /status, sets some more environment,
# and cleans out a variety of files left-over from previous run.
# It runs some utility scripts to ensure the Menu is correct.
# Then it edits the welcome message from vncserver, and launches the GUI.
# Finally, it sources ~/.bashrc.

# Normally, you will never need to use su to change to root.
# But if you do, this file is not re-read when you exit root,
# so the GUI is not double-launched.

source /status # Get stored variables.
echo -e "\e[1;92mStarting Alaterm. Just a moment...\e[0m"
export EDITOR=/usr/bin/nano # User may over-ride.
export VISUAL=/usr/bin/nano # As above.
export BROWSER=/usr/bin/netsurf # User may over-ride, but unlikely.
export TMPDIR=/tmp # In Alaterm, not Android.
export ANDROID_DATA=/data # Same in Android, Termux, and Alaterm.
export ANDROID_ROOT=/system # Same in Android, Termux, and Alaterm.
export EXTERNAL_STORAGE=/sdcard # Actually onboard storage, not removable.
# Use Android native ps and top, if available, rather than Arch programs.
# Do this at each login, in case Arch updates ps or top:
if [ -f /usr/bin/ps ] && [ ! -L /usr/bin/ps ] ; then
	mv /usr/bin/ps /usr/bin/ps.arch
	ln -s /system/bin/ps /usr/bin/ps
fi
if [ -f /usr/bin/top ] && [ ! -L /usr/bin/top ] ; then
	mv /usr/bin/top /usr/bin/top.arch
	ln -s /system/bin/top /usr/bin/top
fi
# Clear left-over tmp from previous launch:
rm -f /tmp/.*lock*
rm -r -f /tmp/.*X11*
rm -r -f /tmp/*
rm -f /tmp/*
# Corrects for overly-enthusiastic user removal of unused locales:
touch /usr/share/locale/locale.alias
# Make annoying and useless desktop message go away:
rm -f /etc/xdg/autostart/lxpolkit.desktop
[ -f /usr/bin/lxpolkit ] && mv -f /usr/bin/lxpolkit /usr/bin/lxpolit.bak
# For use with dbus-run-session:
mkdir -p /tmp/runtime-user
export XDG_RUNTIME_DIR=/tmp/runtime-user
# Prevent ~/.cache and .bash_history from growing ever-larger:
rm -r -f ~/.cache
mkdir -p ~/.cache
c=/home/.cache/1-README
echo "This ~/.cache directory is emptied at each login." > "$c"
echo "Do not put anything here, if you need it later." >> "$c"
echo "Anything in ~/.cache was created at current login" >> "$c"
echo "and may increase during your current session." >> "$c"
rm -f ~/.lectured-root # Also remove this marker file, if present.
rm -f ~/.bash_history
# Ensure that the authority files, if present, are only for current session:
rm -f ~/.Xauthority && touch ~/.Xauthority
rm -f ~/.X11authority && touch ~/.X11authority
rm -f ~/.ICEauthority && touch ~/.ICEauthority
# Ensure no left-over .vnc files:
rm -f ~/.vnc/localhost*
# Launch GUI:
export DISPLAY=:1
# Prevent non-working programs from showing in LXDE Menu:
ban-menu-items 2>/dev/null # In /usr/local/scripts
# Ensure that certain basic programs are always default for their mimetypes:
edit-mimeinfo-cache 2>/dev/null # In /usr/local/scripts
# Edit the vncserver welcome message. Re-do at each login, in case of update.
# Also keep a copy of the pre-edited file, in case of error:
bv="/bin/vncserver"
[ ! -f "$bv.bak" ] && cp "$bv" "$bv.bak"
newhost="New \$host:\$displayNumber"
newhost+=" at 127.0.0.1:590\$displayNumber.\\n"
newhost+="View LXDE Desktop in VNC Viewer app. Password: password\\n"
newhost+="To leave Alaterm and return to Termux: logout\\\n"
sed -i "/.*warn.*desktop is.*/c\warn \"$newhost\";" "/bin/vncserver"
sed -i '/.*warn.*applications specified in.*/c\warn "\\n";' "$bv"
sed -i '/.*warn.*og file is.*/c\warn "\\n";' "$bv"
sed -i 's/^warn "\\n";//g' "$bv"
sleep .1
printf "\e[92m" # Colorizes the messages from vncserver.
vncserver
printf "\e[0m" # End colorize.
sleep .1
#
[ -f /home/.bashrc ] && source /home/.bashrc # For both login and non-login.
##
