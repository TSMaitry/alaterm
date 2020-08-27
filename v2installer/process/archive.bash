# Part of Alaterm, version 2.
# Routine for downloading and checking the Arch Linux ARM archive and md5.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
        echo "This file is not stand-alone."
        echo "It must be sourced from alaterm-installer."
        echo exit 1
fi


# When the os.archlinuxarm.org web page is requested by wget,
#   the downloaded file is HTML, not very useful. Tossed to /dev/null.
# But wget writes its log to stderr unless redirected by the -o option.
# Here, -o captures the log as file archMirrorInfo.
# The responding server, which was chosen via geolocation,
#   is on the line beginning with Location:
#   and can be isolated as the second entry on that line, using awk.
select_geoMirror() {
	cd "$here"
	touch archMirrorInfo # File must exist before wget can write there.
	how="--tries=3 --waitretry=6 os.archlinuxarm.org"
	wget -v -O /dev/null -o archMirrorInfo $how
	if [ "$?" -eq 0 ] ; then
		tMirror="$(grep Location: archMirrorInfo | awk {'print $2'})"
		echo -e "$INFO Geo-chosen mirror $tMirror." # Temporary.
	else
		echo -e "$INFO Was unable to contact geo-mirror list."
		select_otherMirror
	fi
	rm -f archMirrorInfo
} # End select_geoMirror.

select_otherMirror() { # If previous selection fails.
	echo -e "$INFO Manual mirror selection."
	echo "  Choose. Lanugage does not matter:"
	echo "  1 = Aachen, Germany"
	echo "  2 = Miami, Florida, USA"
	echo "  3 = Sao Paolo, Brazil"
	echo "  4 = Johannesburg, South Africa"
	echo "  5 = Sydney, Australia"
	echo "  6 = New Taipei City, Taiwan"
	echo "  7 = Budapest, Hungary"
	echo "  Anything else does nothing, and exits."
	printf "$ENTER your choice [1-7] : " ; read r
	case "$r" in
		1 )	tMirror="de3.mirror.archlinuxarm.org" ;;
		2 )	tMirror="fl.us.mirror.archlinuxarm.org" ;;
		3 )	tMirror="br2.mirror.archlinuxarm.org" ;;
		4 )	tMirror="za.mirror.archlinuxarm.org" ;;
		5 )	tMirror="au.mirror.archlinuxarm.org" ;;
		6 )	tMirror="tw.mirror.archlinuxarm.org" ;;
		7 )	tMirror="hu.mirror.archlinuxarm.org" ;;
		* )	echo -e "$PROBLEM You did not select a mirror."
			exit 1 ;;
	esac
	echo -e "$INFO Using selected mirror $tMirror." # Temporary.
} # End select_otherMirror.

download_archive() { # Into $alatermTop.
	cd "$alatermTop"
	echo -e "$INFO Attempting to download archive..."
	md="$tMirror/os/$yourArchive.md5"
	ar="$tMirror/os/$yourArchive"
	wget -c --show-progress --tries=4 --waitretry=5 $md $ar
	if [ "$?" -ne 0 ] ; then
		echo -e "$WARNING Download incomplete or unsuccessful."
		echo "  Poor Internet connection, server problem, or chance."
		echo "  Here are your choices:"
		echo "  r = Retry now. Might work, might not."
		echo "      Retains partial download. Completed if possible."
		echo "  m = Manually choose different mirror, and try again."
		echo "      Discards partial download. Gets fresh download."
		echo "  x = Exit script. Wait awhile, and try again."
		echo "      Retains partial download. Completed if possible."
		while true ; do
			printf "$ENTER your choice. [r|m|x] : " ; read r
			case "$r" in
				r*|R* )	retry_downloadNow ; break ;;
				m*|M* )	select_otherMirror ; break ;;
				x*|X* )	exit 1 ; break ;;
				* ) 	echo "No default. You must choose." ;;
			esac
		done
	else
		echo -e "$INFO Files downloaded successfully."
	fi
} # End download_archive.

retry_downloadNow() { # If first try fails. If still fails, re-launch script.
	echo "$INFO Re-try of current mirror..."
	sleep 4
	download_archive
} # End retry_downloadNow.

check_archive() { # In $alatermTop.
	cd "$alatermTop"
	printf "$INFO Now checking md5 sum... "
	if md5sum -c "$yourArchive.md5" >/dev/null ; then
		echo "Success."
		echo "chosenMirror=$tMirror" >> status
		export chosenMirror="$tMirror"
		echo "gotArchive=yes" >> status
	else
		echo -e "$PROBLEM"
		echo "Cannot continue when md5 fails."
		echo "Re-launch script for fresh download."
		echo "Bad download removed from Alaterm."
		# Removes download:
		rm -f "$yourArchive" "$yourArchive.md5" 2>/dev/null
		exit 1
	fi
} # End check_archive.


# Procedure for this part:
trap scriptSignal HUP INT TERM QUIT # Message, then exit.
trap scriptExit EXIT # Releases wakelock on any exit.
start_termuxWakeLock # May allow faster install.
echo -e "$INFO Will now access Internet."
select_geoMirror # Or manual choice, if fail.
download_archive
sleep .2
check_archive
sleep .2
##
