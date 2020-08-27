#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/dbus-programs
#
# Variable progdbus is a list of programs known to request dbus session.
# Some of them may be installed into Alaterm, others not.
# If an installed program is in progdbus, its *.desktop file is modified
# to use dbus-run-session, when the program is launched from the Menu.
# Does not affect programs launched from command line.

# When additional programs requiring dbus-run-session
# are discovered, add them to progdbus.
# Also provide an update for existing installations.

# Note that the *.desktop filename sometimes differs from the program name.
# For example, the program gedit uses org.gnome.gedit.desktop.
# When adding lines by +=, note that space follows the opening quotes.

progdbus="org.gnome.gedit org.gnome.font-viewer gimp"
progdbus+=" lxappearance kid3-qt ciano inkscape hugin"

##
usa="/usr/share/applications"
edrs="Exec=dbus-run-session " # Note space.
hlsa="/home/.local/share/applications"
mkdir -p "$hlsa" && cd "$hlsa"

for p in "$progdbus" ; do
	if [ -f "$usa/$p.desktop" ] ; then
		cp "$usa/$p.desktop" "."
		sed -i 's!Exec=!$edrs!' "$p.desktop"
	else
		rm -f "$p.desktop"
	fi
done
##
