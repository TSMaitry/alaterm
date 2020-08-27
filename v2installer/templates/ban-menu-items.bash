#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/ban-menu-items
# Script ban-menu-items, created by Alaterm installer.

# This is an ESSENTIAL feature of Alaterm. Do not delete this file.

# Prevents useless or redundant applications from appearing on LXDE Menu.
# Runs during install, launch, and after each pacman install or upgrade.
# Creates or over-writes desktop items in ~/.local/applications.

lsa="/home/.local/share/applications"
declare -A nomenu # Declared as an array.
nomenu[avahi-discover]="Avahi Zeroconf Browser"
nomenu[blocks]="Block Attack!"
nomenu[bssh]="Avahi SSS Server Browser"
nomenu[bvnc]="Avahi VNC Server Browser"
nomenu[checkers]="Checkers"
nomenu[cups]="Manage Printers"
nomenu[fluid]="FLTK GUI Designer"
nomenu[gtk3-demo]="GTK+ Demo"
nomenu[gtk3-icon-browser]="Icon Browser"
nomenu[gtk3-widget-factory]="Widget Factory"
nomenu[io.elementary.granite.demo]="Granite Demo"
nomenu[libfm-pref-apps]="Preferred Applications"
nomenu[libreoffice-base]="LibreOffice Base"
nomenu[libreoffice-calc]="LibreOffice Calc"
nomenu[uxterm]="UXTerm"
nomenu[libreoffice-draw]="LibreOffice Draw"
nomenu[libreoffice-impress]="LibreOffice Impress"
nomenu[libreoffice-math]="LibreOffice Math"
nomenu[lstopo]="Hardware Locality lstopo"
nomenu[lxde-logout]="Logout"
nomenu[lxde-screenlock]="ScreenLock"
nomenu[lxsession-default-apps]="Default applications for LXSession"
nomenu[lxsession-edit]="Shortcut Editor"
nomenu[lxterminal]="LXTerminal"
nomenu[openbox]="Openbox"
nomenu[sudoku]="Sudoku"
nomenu[qv4l2]="Qt V4L2 test Utility"
nomenu[qvidcap]="Qt V4L2 video capture utility"
nomenu[vncviewer]="TigerVNC Viewer"
nomenu[xdvi]="XDvi"
nomenu[assistant]="Qt Assistant"
nomenu[designer]="Qt Designer"
nomenu[linguist]="Qt Linguist"
nomenu[qdbusviewer]="Qt dbus Viewer"
nomenu[cmake-gui]="Cmake GUI"

# stackoverflow.com q. 3112687 answers by Paused Until and Michael O:
for i in "${!nomenu[@]}" ; do
	if [ -f "/usr/share/applications/$i.desktop" ] ; then
		echo "[Desktop Entry]" > "$lsa/$i.desktop"
		echo "Name=${nomenu[$i]}" >> "$lsa/$i.desktop"
		echo "Type=Application" >> "$lsa/$i.desktop"
		echo "NoDisplay=true" >> "$lsa/$i.desktop"
	elif [ -f "$lsa/$i.desktop" ] ; then
		rm -f "$lsa/$i.desktop"
	fi
done
##
