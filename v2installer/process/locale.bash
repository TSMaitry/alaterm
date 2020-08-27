# Part of Alaterm, version 2.
# Routine for setting locale.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi


# Locale is of form xy_AB where xy is lowercase letters = language code,
#   and AB is uppercase letters = geographic variant.
# There are other codes for special locales, not recognized here.
# This can be stored in several different parameters, depending on system.
# The following code hunts through the parameters, by priority.
# Default is en_US if nothing else is found.
find_locale() {
	# Arch provides /etc/locale.gen, a commented-out list of locales.
	g="$alatermTop/etc/locale.gen"
	grep laterm "$g" /dev/null 2>&1 # Might be Alaterm or alaterm.
	[ "$?" -eq 0 ] && return # Already did this.
	ul="$(getprop user.language)"
	ur="$(getprop user.region)"
	psla="$(getprop persist.sys.language)"
	psc="$(getprop persist.sys.country)"
	rpll="$(getprop ro.product.locale.language)"
	rplr="$(getprop ro.product.locale.region)"
	pslo="$(getprop persist.sys.locale)"
	rpl="$(getprop ro.product.locale)"
	if [ "$ul" != "" ] && [ "$ur" != "" ] ; then
		userLocale="$ul"_"$ur"
	elif [ "$psla" != "" ] && [ "$psc" != "" ] ; then
		userLocale="$psla"_"$psc"
	elif [ "$rpll" != "" ] && [ "$rplr" != "" ] ; then
		userLocale="$rpll"_"$rplr"
	elif [[ "$pslo" =~ _ ]] ; then # underscore
		userLocale="$pslo"
	elif [[ "$pslo" =~ \- ]] ; then # hyphen
		userLocale="$(echo $pslo | sed 's/-/_/')"
	elif [[ "$rpl" =~ _ ]] ; then # underscore
		userLocale="$rpl"
	elif [[ "$rpl" =~ \- ]] ; then # hyphen
		userLocale="$(echo $rpl | sed 's/-/_/')"
	else
		userLocale="$defaultLocale" # Set in globals.bash.
	fi
	if [ -f "$g" ] ; then # Uncomments line for above locale:
		sed -i "/\\#$userLocale.UTF-8 UTF-8/{s/#//g;s/@/-at-/g;}" "$g"
	else # No file? Create it:
		echo "$userLocale.UTF-8 UTF-8" > "$g"
	fi
} # End find_locale.


# Perform above functions:
find_locale
install_template "locale.conf"
sleep .2
LANG="$userLocale.UTF-8" # Always UTF-8.
echo "export userLocale=$userLocale" >> "$alatermTop/status"
echo "export LANG=$userLocale.UTF-8" >> "$alatermTop/status"
echo "localeSet=yes" >> "$alatermTop/status"
echo -e "$INFO Will use locale $userLocale and LANG $LANG."
##
