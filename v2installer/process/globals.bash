# Part of Alaterm, version 2.
# Routine for setting global variables and functions.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
        echo "This file is not stand-alone."
        echo "It must be sourced from alaterm-installer."
        echo exit 1
fi


# GLOBAL VARIABLES:
# ----------------------------------------------------------------------------
# Used throughout the script sequence by various files.
# Variable $here was set in alaterm-installer.
#
# Colors used for various messages, colored word folowed by plain text:
export PROBLEM="\e[1;91mPROBLEM:\e[0m" # Bold Red.
export WARNING="\e[1;33mWARNING:\e[0m" # Bold Yellow.
export INFO="\e[92mInfo:\e[0m" # Green.
export ENTER="\e[1mEnter\e[0m" # Bold, user input.
export DONE="\e[92mDONE.\e[0m" # Green.
# termuxTop should be /data/data/com.termux, but measure it anyway:
export termuxTop="$HOME/../../" # Highest writeable directory in Termux.
cd "$termuxTop" && termuxTop=`pwd` # Expands to /data/data/com.termux.
declare termuxPrefix="$PREFIX" # Equivalent of /usr, within Termux.
declare termuxHome="$HOME" # Where Termux is, at start.
# Alaterm is installed where it does not mingle with Termux /usr or /home.
# Standard location is $termuxTop/alaterm, on-board device, within Termux app.
declare alatermTop="$termuxTop/alaterm" # Highest rwx directory in Termux.
declare launchCommand="alaterm" # As used by Termux.
# ABI is Android-speak for its operating system. Not same as version number.
# As of mid-2020 these two are known, plus Chromebook version of armeabi-v7a:
declare abi32="armeabi-v7a" # 32-bit. May or may not be Chromebook.
declare abi64="arm64-v8a" # 64-bit. Do not confuse with 32-bit arm-v8l CPU.
declare yourABI="unknown" # Will be measured.
# Matching archive distributions of Arch Linux ARM:
declare archiveCB32="ArchLinuxARM-armv7-chromebook-latest.tar.gz"
declare archive32="ArchLinuxARM-armv7-latest.tar.gz"
declare archive64="ArchLinuxARM-aarch64-latest.tar.gz"
declare yourArchive="unknown" # Will be selected based on ABI.
# Archive-specific packages that cannot be used in Alaterm:
declare delete32="linux-firmware linux-armv7"
declare delete64="linux-firmware linux-aarch64"
declare yourDelete="unknown" # Will be selected based on ABI.
#
# Provision for newer Android ABI.
# Below, the linux-* is not meant to be a wildcard.
# You must write some specific package name there.
declare abiALT1="unknown" # New ABI1.
declare archiveALT1="unknown" # Corresponding archive at Arch Linux ARM.
declare deleteALT1="linux-firmware linux-*" # Change * to whatever.
declare abiALT2="unknown" # New ABI2.
declare archiveALT2="unknown" # Corresponding archive at Arch Linux ARM.
declare deleteALT2="linux-firmware linux-*" # Change * to whatever.
#
declare defaultLocale="en_US"
declare isRooted="no" # Issues warning if your device is rooted.
declare termuxProxy="no" # Issues warning if Termux has proxy server.
declare preInstallFreeSpace="unknown" # Becomes integer GB available.
let userSpace=-1 # For free space calculation.
let processors=-1 # Becomes number of processors in CPU: 4, 6, 8.
#
declare tMirror="notSelected" # Temporary choice, not known whether good.
declare chosenMirror="notSelected" # Becomes known good mirror, once found.
declare wakelockNoted="no" # One-time lecture.
declare wakelockOn="no" # Becomes yes when on.
let scriptRevision=0 # Becomes thisRevision upon completion.
#
# Get variables stored by previously running this script, if any.
# The chmod corrects possible mis-coding from earlier testing:
[ -d "$alatermTop" ] && chmod 755 "$alatermTop"
#
if [ -f "$alatermTop/status" ] ; then
	chmod 644 "$alatermTop/status"
	source "$alatermTop/status"
fi
##


# FUNCTIONS CALLED FROM ANOTHER INSTALLER FILE:
# ----------------------------------------------------------------------------

create_statusFile() { # In $alatermTop. Stores progress and global variables.
	mkdir -p "$alatermTop" && cd "$alatermTop"
	cat <<- EOC > status # Hyphen. Unquoted marker. Single gt.
	# File /status created by script during install.
	# Records progress of installation by Termux.
	# Retains important data for use by Alaterm after installation.
	#
	# DO NOT EDIT OR REMOVE THIS FILE.
	#
	repository="$repository"
	# Message colors:
	export PROBLEM="\e[1;91mPROBLEM:\e[0m" # Bold Red.
	export WARNING="\e[1;33mWARNING:\e[0m" # Bold Yellow.
	export INFO="\e[92mInfo:\e[0m" # Green.
	export ENTER="\e[1mEnter\e[0m" # Bold, user input.
	# Recorded when device compatibility approved:
	export installerVersion="$versionID"
	scriptLocation="$here"
	export termuxTop="$termuxTop"
	export termuxPrefix="$PREFIX"
	export TUSR="$PREFIX" # Version compatibility.
	export termuxHome="$HOME"
	export THOME="$HOME" # Version compatibility.
	export termuxLdPreload="$LD_PRELOAD"
	export alatermTop="$alatermTop" # Android path.
	export launchCommand="$launchCommand" # Launches Alaterm from Termux.
	isRooted="$isRooted" # Was a rooted device detected?
	termuxProxy="$termuxProxy" # Was a proxy detected?
	abi32="armeabi-v7a" # 32-bit. May or may not be Chromebook.
	abi64="arm64-v8a" # 64-bit. Do not confuse with arm-v8l CPU.
	abiALT1="$abiALT1" # Possible future usage.
	abiALT2="$abiALT2" # Possible future usage.
	export yourABI="$yourABI" # Your device, as measured.
	export CPUABI="$yourABI" # Version compatibility.
	export yourArchive="$yourArchive" # Based on yourABI.
	export archAr="$yourArchive" # Version compatibility.
	yourDelete="$yourDelete" # Which packages deleted.
	preInstallFreeSpace="$preInstallFreeSpace" # Checked once. Integer.
	EOC
	echo "# Added as installer progresses:" >> status
	sleep .1
	chmod 644 status
} # End create_statusFile.

scriptSignal() { # Run on various interrupts.
	echo -e "$WARNING Signal ${?} received."
	echo "Re-launch script to resume where it left off."
	exit 1
} # End scriptSignal.

scriptExit() { # Ensures wakelock is removed.
	if [ "$wakelockOn" = "yes" ] ; then
		termux-wake-unlock >/dev/null 2>&1
		echo "Termux wakelock released. Script exited."
	else
		echo "Script exited."
	fi
} # End scriptExit.

start_termuxWakeLock() { # Prevents Android deep sleep.
	if [ "$wakelockNoted" = "no" ] ; then
		echo -e "$INFO Installer will request wakelock."
		echo "  Android may show popup regarding battery."
		echo "  For faster processing, allow it to stop optimizing."
		echo "  Optimize is restored when the completes or fails."
		echo "  If you deny, the installer still works, but slower."
		printf "$ENTER to continue: " ; read r
		wakelockNoted="yes"
		echo "wakelockNoted=yes" >> "$alatermTop/status"
	fi
	termux-wake-lock >/dev/null 2>&1
	if [ "$?" -eq 0 ] ; then
		echo -e "$INFO Using Termux wakelock."
		wakelockOn="yes"
	fi
} # End start_termuxWakeLock.

# install_template creates an Alaterm file, from a file in templates folder.
install_template() { # Takes 1 or 2 arguments: filename in /templates, chmod.
	t="$here/templates/$1"
	if [ ! -f "$t" ] ; then
		echo -e "$PROBLEM install_template cannot locate file:"
		echo "  templates/$1"
		exit 1
	fi
	if [ "$#" -gt 2 ] ; then
		echo -e "$PROBLEM More than 2 arguments for:"
		echo "  install_template $1"
		exit 1
	fi
	if [ "$#" = "2" ] ; then # Optional chmod.
		ok="no"
		[[ "$2" =~ ^[1-7][0-7][0-7]$ ]] && ok="yes" # 3 digits.
		[[ "$2" =~ ^[0=7][1-7][0-7][0-7]$ ]] && ok="yes" # 4 digits.
		if [ "$ok" != "yes" ] ; then
			echo -e "$PROBLEM Bad chmod code $2 for:"
			echo "  install_template $1."
			exit 1
		fi
	fi
	fs="" # Initialize.
	fs="$(grep "laterm:file=" $t 2>/dev/null)" # Find the instruction.
	# Extract destination filename from filestring:
	fs="$(echo $fs | sed 's/.*laterm:file=//')"
	fs="$(echo $fs | sed 's/ .*//')" # Destination ends at space.
	if [ "$fs" = "" ] ; then
		echo -e "$PROBLEM Cannot find instruction, Alaterm:file="
		echo "  in templates/$1."
		exit 1
	fi
	# Expand filestring variables, if present.
	# These are paths containing / so alternative ! must be used in sed:
	fs="$(echo $fs | sed "s!\$alatermTop!$alatermTop!")"
	fs="$(echo $fs | sed "s!\$PREFIX!$PREFIX!")"
	fs="$(echo $fs | sed "s!\$HOME!$HOME!")"
	fs="$(echo $fs | sed "s!\$launchCommand!$launchCommand!")"
	# If necessary, create the directory path:
	dir="$(echo $fs | sed 's![^/]*$!!')" # Path only.
	mkdir -p "$dir" 2>/dev/null
	if [ "$?" -ne 0 ] ; then
		echo "$PROBLEM Cannot create directory:"
		echo "  $dir"
		echo "  required by install_template $1."
		exit 1
	fi
	sleep .05
	cp "$t" "$fs"
	sleep .05
	sed -i '/laterm:file=/d' "$fs" # Remove instruction line.
	# After removing instruction, most templates are installed verbatim.
	# Use PARSE for variables that must be expanded there.
	sed -i "s!PARSE\$launchCommand!$launchCommand!" "$fs"
	sed -i "s!PARSE\$alatermTop!$alatermTop!" "$fs"
	sed -i "s!PARSE\$userLocale!$userLocale!" "$fs"
	sed -i "s!PARSE\$PREFIX!$PREFIX!" "$fs" # Termux.
	sed -i "s!PARSE\$HOME!$HOME!" "$fs" # Termux.
	# chmod if specified:
	if [ "$#" = "2" ] ; then
		chmod "$2" "$fs"
	else
		chmod 644 "$fs"
	fi
	sleep .05
} # End install_template.

# Developer-only routine for testing templates, without real installation:
if [[ "$here" =~ TAexp-min ]] ; then # Specially-named folder.
	alatermTop="$alatermTop-dev"
	launchCommand="$launchCommand-dev"
	mkdir -p "$alatermTop"
	cd "$here/templates"
	templates="$(ls)"
	echo "Reading templates..."
	for template in $templates ; do # No quotes.
		if [[ "$template" =~ bash$ ]] ; then
			install_template "$template" 755
		else
			install_template "$template"
		fi
	done
	cp "$alatermTop/usr/local/scripts/$launchCommand" "$PREFIX/bin/"
	echo "Developer exit."
	exit 0
fi
##
