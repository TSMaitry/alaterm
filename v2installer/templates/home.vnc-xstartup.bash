#!/bin/bash
# Alaterm:file=$alatermTop/home/.vnc/xstartup
# File /home/.vnc/xstartup edited by Alaterm installer.
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
source ~/.xinitrc # Over-ride default settings.
# The trailing ampersand keeps this running as a background task:
startlxde &
##
