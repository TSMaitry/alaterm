# Part of Alaterm, version 2.
# Routine for unpacking Arch into proot.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi


unpack_archive() { # Into $alatermTop.
	cd "$alatermTop"
	echo -e "$INFO Unpacking archive is a lengthy operation."
	echo "  There may be 5 to 10 minutes without feedback here."
	echo -e "  \e[1;92mScript did not hang. Be patient...\e[0m"
	lpl="$LD_PRELOAD" # Saves it.
	unset LD_PRELOAD # Unset for proot operation.
	proot --link2symlink -v -1 -0 bsdtar -xpf "$yourArchive"
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Something went wrong during unpack."
		echo "Are you sure you have enough free space?"
		echo "Whatever the cause, this script cannot continue."
		echo "If you try again, script must start from beginning."
		rm -r -f "$alatermTop"
		exit 1
	else
		LD_PRELOAD="$lpl" # Restores it.
	fi
} # End unpack_archive.

copy_mirror() {
	cd "$alatermTop"
	echo "# Mirror for downloaded Arch Linux ARM archive:" > mirrorlist
	echo -e "Server = $chosenMirror\$arch/\$repo\n" >> mirrorlist
	if [ -f "$alatermTop/etc/pacman.d/mirrorlist" ] ; then
		cat "$alatermTop/etc/pacman.d/mirrorlist" >> mirrorlist
		rm -r -f "$alatermTop/etc/pacman.d/mirrorlist"
	else
		mkdir -p "$alatermTop/etc/pacman.d/"
	fi
	mv mirrorlist "$alatermTop/etc/pacman.d/"
} # End copy_mirror.

copy_resolvConf() { #####
	cd "$alatermTop"
	mkdir -p "$alatermTop/run/systemd/resolve"
	rsr="run/systemd/resolve"
	if [ -f "$PREFIX/etc/resolv.conf" ] ; then # Use whatever Termux uses.
		cp -f "$PREFIX/etc/resolv.conf" "$alatermTop/$rsr/"
	else # Use Google DNS.
		echo "nameserver 8.8.8.8" > "$alatermTop/$rsr/resolv.conf"
		echo "nameserver 8.8.4.4" >> "$alatermTop/$rsr/resolv.conf"
	fi
}


# Procedure for this part:
unpack_archive
install_template "readme-local.md"
# The download mirror used for the archive is known-good. Save its location:
copy_mirror
copy_resolvConf
sleep .2
rm -f "$alatermTop/$yourArchive" # No longer needed.
rm -f "$alatermTop/$yourArchive.md5" # No longer needed.
echo -e "$INFO Success unpacking archive."
echo "unpackedArchive=yes" >> "$alatermTop/status"
sleep .2
##
