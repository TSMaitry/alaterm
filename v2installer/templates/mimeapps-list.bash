#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/mimeapps-list
#
# This selects the simplest default application for the indicated mimetypes,
# in cases where a mimetype might have several choices.
# If one choice, or choice is indifferent, then it is not listed here.
# This script is automatically re-run after using pacman.

file="/home/.config/mimeapps.list"
og="org.gnome"
echo "[Default Applications]" > "$file"
if [ -f /usr/bin/ghex ] ; then # Hex editor. Use only if necessary!
	echo "application/x-sharedlib=$og.GHex.desktop;" >> "$file"
fi
if [ -f /usr/bin/leafpad ] ; then # Simple plain text editor.
	echo "inode/x-corrupted=leafpad.desktop;" >> "$file"
	echo "text/plain=leafpad.desktop;" >> "$file"
fi
if [ -f /usr/bin/evince ] ; then # Evince is Document Viewer in the Menu.
	echo "application/illustrator=$og.Evince.desktop;" >> "$file"
	echo "application/pdf=$og.Evince.desktop;" >> "$file"
	echo "application/postscript=$og.Evince.desktop;" >> "$file"
	echo "image/x-eps=$og.Evince.desktop;" >> "$file"
fi
if [ -f /usr/bin/libreoffice ] ; then
	echo "application/vnd.corel-draw=libreoffice-draw.desktop;" >> "$file"
	echo "image/x-wmf=libreoffice-draw.desktop;" >> "$file"
fi
if [ -f /usr/bin/font-viewer ] ; then # simple font viewer.
	echo "application/x-font-otf=$og.font-viewer.desktop;" >> "$file"
	echo "application/x-font-pcf=$og.font-viewer.desktop;" >> "$file"
	echo "application/x-font-ttf=$og.font-viewer.desktop;" >> "$file"
	echo "application/x-font-type1=$og.font-viewer.desktop;" >> "$file"
	echo "font/otf=$og.font-viewer.desktop;" >> "$file"
	echo "font/ttf=$og.font-viewer.desktop;" >> "$file"
fi
if [ -f /usr/bin/gpicview ] ; then # Simple image viewer.
	echo "image/bmp=gpicview.desktop;" >> "$file"
	echo "image/gif=gpicview.desktop;" >> "$file"
	echo "image/jpeg=gpicview.desktop;" >> "$file"
	echo "image/png=gpicview.desktop;" >> "$file"
	echo "image/svg+xml=gpicview.desktop;" >> "$file"
	echo "image/tiff=gpicview.desktop;" >> "$file"
	echo "image/x-pcx=gpicview.desktop;" >> "$file"
	echo "image/x-portable-bitmap=gpicview.desktop;" >> "$file"
	echo "image/x-portable-graymap=gpicview.desktop;" >> "$file"
	echo "image/x-portable-greymap=gpicview.desktop;" >> "$file"
	echo "image/x-portable-pixmap=gpicview.desktop;" >> "$file"
	echo "image/x-tga=gpicview.desktop;" >> "$file"
	echo "image/heic=gpicview.desktop;" >> "$file"
	echo "image/heif=gpicview.desktop;" >> "$file"
fi
if [ -f /usr/bin/netsurf ] ; then # Browser.
	echo "application/xml=netsurf.desktop;" >> "$file"
	echo "text/html=netsurf.desktop;" >> "$file"
fi
##
