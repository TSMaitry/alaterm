#/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/autoremove
# Script autoremove, created by Alaterm installer.

# This is an EXTRA feature, not essential.

# Removes unnecessary packages that were installed as dependencies.
# Works something like Debian: apt autoremove
sudo pacman -Qdtq | sudo pacman --noconfirm -Rs - >/dev/null 2>&1
echo "Autoremoved unnecessary packages, if any."
##
