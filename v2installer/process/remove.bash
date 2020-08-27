# Part of Alaterm, version 2.
# Routine for removing Alaterm.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi


# This routine removes Alaterm.

# If nothing found, nothing to do:
if [ ! -d "$termuxTop/alaterm" ] ; then
	echo -e "$PROBLEM No Alaterm in expected location."
	echo "If you installed to a non-standard location,"
	echo "then you will have to uninstall manually."
	exit 1
fi

remove_dir() {
	# Two-cycle is faster than chmod everything:
	a="$termuxTop/alaterm"
	# 1. First remove easy stuff.
	chmod 755 "$a" # In case it was read-only.
	rm -r -f "${a:?}/*" # Removes most of the stuff.
	# 2. Anything remaining needs chmod:
	atls="$(ls -A $a)" 2>/dev/null
	if [ "$atls" != "" ] ; then
		find "$a" -type d -exec chmod 755 {} \; 2>/dev/null
	fi
	# Now remove the rest:
	rm -r -f "$a"
	# Remove the launch command and other stuff:
	rm -f "$PREFIX/bin/alaterm"
	rm -f "$PREFIX/bin/query-tvnc"
	sed -i '/laterm/d' "$HOME/.bashrc" # In Termux ~/.bashrc.
	sleep .2
	printf "\e[1;92mDONE.\e[0m\n"
	exit 0
} # End remove_dir.

echo -e "\e[1mWhat do you wish to do?\e[0m"
echo "  r = Remove Alaterm. No files retained."
echo "  x = Exit. Do nothing."
printf "$Enter one choice [r|X] : " ; read c
case "$c" in
	r*|R* )	printf "Remove Alaterm. Are you sure? [y|N] : "
		read s
		case "$s" in
			y*|Y* )	echo "Removing Alaterm. Takes 2-3 min..."
				remove_dir ;;
			* )	echo "You did not confirm. Nothing done."
				exit 0 ;;
		esac ;;
	* )	echo "You chose to exit. Nothing done."
		exit 0 ;;
esac
##
