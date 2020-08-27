# Part of Alaterm, version 2.
# Routines for initial compatibility checks.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi


check_directory() {
	if [ "$alatermTop" = "/" ] ; then # Naughty customization!
		echo -e "$PROBLEM Cannot install Alaterm at Android root."
		exit 1
	fi
	mkdir -p "$alatermTop" 2>/dev/null # It may already exist.
	if [ "$?" -ne 0 ] ; then # Unlikely to fail.
		echo -e "$PROBLEM Cannot create installation directory."
		echo "Its parent directory is not writeable." ; exit 1
	else # Do not leave empty directory if user decides not to install:
		rm -d "$alatermTop" 2>/dev/null # Re-created with status file.
	fi
} # End check_directory.

check_priorInstall() { # Anything already in same location?
	if [ -f "$alatermTop/bin/env" ] && [ -f "$alatermTop/bin/pacman" ]
	then # Using /bin/env and /bin/pacman as likely markers of install.
		if [ ! -f "$alatermTop/status" ] ; then # Bad prior install.
			echo -e "$PROBLEM Installer cannot continue."
			echo "Corrupted prior installation was found."
			echo "It must be removed before you can install anew:"
			echo "  bash alaterm-installer remove"
			echo -e "$WARNING That removes ALL files in Alaterm,"
			echo "including files saved in its home directory."
			exit 1
		fi
	fi
} # End check_priorInstall.

check_ABI() { # Check Android software compatibility.
	hash getprop >/dev/null 2>&1
	if [ "$?" -ne 0 ] ; then
		echo -e "$INFO Must upgrade Termux first..."
		apt-get update && apt-get dist-upgrade -y >/dev/null 2>&1
		if [ "$?" -ne 0 ] ; then
			echo -e "$PROBLEM Could not get Termux upgrade."
			echo "Check Internet, then try again."
			exit 1
		fi
	fi
	yourABI="$(getprop ro.product.cpu.abi)" >/dev/null 2>&1
	if [ "$yourABI" = "$abi32" ] ; then
		gotCheet="$(getprop ro.product.device)" >/dev/null 2>&1
                if [[ "$gotCheet" =~ _cheet ]] ; then # Chromebook: eve_cheets
                        yourArchive="$archiveCB32"
                else
                        yourArchive="$archive32"
                fi
		yourDelete="$delete32"
	elif [ "$yourABI" = "$abi64" ] ; then
		yourArchive="$archive64"
		yourDelete="$delete64"
	elif [ "$yourABI" = "$abiALT1" ] ; then
		yourArchive="$archiveALT1"
		yourDelete="$deleteALT1"
	elif [ "$yourABI" = "$abiALT2" ] ; then
		yourArchive="$archiveALT2"
		yourDelete="$deleteALT2"
	else # Device did not match known ABI.
		echo -e "$PROBLEM Your device has unknown ABI."
		echo "Detected ABI:  $yourABI"
		echo "Perhaps a new ABI can be entered in file globals.bash."
		exit 1
	fi
} # End check_ABI.

check_kernel() { # Must be major version 4 or more. Almost certainly true.
	let krel=0
	ks="$(echo "$(uname -r)" | gawk -F'.' '{print $1}')" 2>/dev/null
	[[ "$ks" =~ ^[0-9]*$ ]] && let krel=$ks # No quotes.
	if [ "$krel" -eq 0 ] ; then
		echo -e "$WARNING Could not get kernel version."
		echo "Script can assume kernel is OK, and continue."
		echo "The result may or may not have problems. Unpredictable."
		echo "Do you wish to install, or not?"
		printf "$ENTER your choice [y|N] : " ; read r
		case "$r" in
			y*|Y* ) echo "Continuing at your request..."
			let krel=4 ;;
			* ) echo "You did not answer y."
			exit 1 ;;
		esac
	fi
	if [ "$krel" -lt 4 ] ; then
		echo -e "$PROBLEM Your system is not compatible."
		echo "Reason: Android kernel release less than 4."
		echo "Or, device security blocked essential information."
		exit 1
	fi

} # End check_kernel.

check_freeSpace() { # Improved in script version 1.2.6.
	dataline="$(df -h . 2>/dev/null | grep /data$)"
	dataline="$(echo $dataline | gawk 'FNR == 1 {print $4}')" 2>/dev/null
	if [[ "$dataline" =~ G ]] ; then
		datanum="$(echo $dataline | sed 's/G//g' | sed 's/\..*//g')"
		if [[ "$datanum" =~ ^[0-9]*$ ]] ; then
			let userSpace="$((datanum + 0))"
		fi
	fi
	if [ "$userSpace" -eq -1 ] ; then
		echo -e "$WARNING Test was unable to calculate free space."
		echo "Check free space manually, using Android file manager."
		echo "Do not include removable media."
		echo "After that check, what do you wish to do?"
		echo "  p = Proceed. At least 3G internal free space."
		echo "  x = Exit. Not enough space."
		printf "$ENTER your choice: [p|X] : " ; read r
		case "$r" in
			p*|P* ) echo "Continuing, at your request..." ;;
			* ) echo "You did not request to proceed."
				echo "Consider cleaning out unused files."
				exit 1 ;;
		esac
	elif [ "$userSpace" -lt 3 ] ; then
		echo -e "$PROBLEM Your system is not compatible."
		echo "Reason: Less than 3G internal free space available."
		echo "Or, device security blocked essential information."
		exit 1
	elif [ "$userSpace" -lt 4 ] ; then
		echo -e "$WARNING Test reports 3G-4G free space."
		echo "  Enough for minimal Alaterm, not many useful programs."
	elif [ "$userSpace" -lt 5 ] ; then
		echo -e "$WARNING Test reports 4G-5G free space."
		echo "  Enough for Alaterm and a few useful programs."
	else
		echo -e "$INFO Test reports over 5G free space."
		echo "  Enough for Alaterm and many useful programs."
	fi
	if [ "$userSpace" -ne -1 ] ; then
		preInstallFreeSpace="$userSpace"
		preInstallFreeSpace+="G"
	fi
} # End check_freeSpace.

caution_rooters() { # Developer unable to test rooted system. Effects unknown.
	ls / >/dev/null 2>&1
	[ "$?" -eq 0 ] && isRooted="yes"
	tsudo ls / >/dev/null 2>&1
	[ "$?" -eq 0 ] && isRooted="yes"
	[ -w /root ] && isRooted="yes"
	if [ "isRooted" = "yes" ] ; then # Above tests are not exhaustive.
		echo -e "$WARNING It looks like your device is rooted."
		echo "Rooted performance is unknown and unmaintained."
		printf "Do you really wish to install? [y|N] : " ; read r
		case "$r" in
			y*|Y* ) echo "At your request, continuing..." ;;
			* ) echo -e "You did not answer yes. No change."
				exit 1 ;;
		esac
	fi
} # End caution_rooters.

ignore_proxy() { # If Termux has proxy, this script does not copy it.
	for prx in "$PREFIX/etc/profile" "$PREFIX/etc/profile.d/proxy.sh" ; do
		if [ -e "$prx" ] ; then
			grep "proxy" "$prx" | grep "export" > /dev/null
			[ "$?" -eq 0 ] && termuxProxy="ignored"
		fi
	done
	for prx in "~/.profile" "~/.bash_profile" "~/.bashrc" ; do
		if [ -e "$prx" ] ; then
			grep "proxy" "$prx" | grep "export" > /dev/null
			[ "$?" -eq 0 ] && termuxProxy="ignored"
		fi
	done
	if [ "$termuxProxy" = "ignored" ] ; then
		echo -e "$WARNING Looks like you have a Termux proxy server."
		echo -e "This script does not configure Alaterm for proxy."
		echo -e "Script will continue. Termux unaffected."
	fi
} # End ignore_proxy.

update_termuxPackages() { # Newly-installed Termux app is incomplete.
	echo "Checking if Termux is up-to-date. Upgrading if necessary..."
	apt-get -y update && apt-get -y dist-upgrade
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Termux could not be updated."
		echo "Possibly bad or erratic Internet connection."
		exit 1
	fi
} # End update_termuxPackages.

get_moreTermux() { # Needed to support Alaterm.
	local getThese=""
	for needPkg in wget bsdtar proot nano ; do
		hash "$needPkg" >/dev/null 2>&1
		[ "$?" -ne 0 ] && getThese+="$needPkg "
	done
	if [ "$getThese" != "" ] ; then
		echo -e "$INFO Some necessary Termux packages are missing."
		echo "  They will now be downloaded and installed..."
		apt-get -y install $getThese 2>/dev/null # Unquoted $getThese.
		if [ "$?" -ne 0 ] ; then
			echo -e "$PROBLEM Some Termux packages unavailable."
			echo "Bad Internet connection, or server is erratic."
			exit 1
		else echo -e "$INFO Installed Termux packages. Continuing..."
		fi
	fi
	if [ "$getThese" != "" ] ; then
		for didItInstall in $getThese ; do # Unquoted $getThese.
			hash "$didItInstall" >/dev/null 2>&1
			if [ "$?" -ne 0 ] ; then
				echo -e "$PROBLEM Having server problems."
				echo -e "Wait awhile, then try again."
				exit 1
			fi
		done
		echo -e "$INFO Successful Termux ugrade. Continuing..."
	fi
} # End get_moreTermux.

verify_storageEnabled() { # So Alaterm communicates with Android file manager.
	ls ~/storage/downloads/ >/dev/null 2>&1
	if [ "$?" -ne 0 ] ; then
		echo -e "$WARNING You did not enable Termux file transfer."
		echo "Or you moved folders to where script cannot find them."
		echo "Without it, you cannot move files in or out of Termux."
		echo "This will now be fixed. Android may show a popup."
		echo "Be sure to allow file sharing permission."
		echo "If you deny, Alaterm cannot use Android file manager."
		printf "$ENTER when you are ready: " ; read r
		termux-setup-storage
		if [ "$?" -ne 0 ] ; then
			echo -e "$WARNING Denied storage access permission."
			echo "  Be sure to run termux-setup-storage later."
		fi
	fi
} # End verify_storageEnabled.


# Sequence of actions:
check_directory # Intended location OK?
check_priorInstall # Anything already there?
check_ABI # Your flavor of Android system. Not same as version number.
check_kernel # Release must be at least 4. Probably is.
check_freeSpace # On-board, not removable.
caution_rooters # Alaterm is primarily for non-rooted devices.
ignore_proxy # If proxy server in Termux, not copied into Alaterm.
update_termuxPackages
get_moreTermux
verify_storageEnabled # For file transfer into or out of Alaterm.
create_statusFile # Records progress of this installer.
echo -e "$INFO Passed preliminary inspection."
echo "checkedCompatibility=yes" >> "$alatermTop/status"
##
