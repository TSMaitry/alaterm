# Part of Alaterm, version 2.
# Routine for creating dummy /proc files, if needed.

echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi


# Some applications want access to processes or devices concealed by Android.
# This problem can often be solved by dummy files, via the bind mechanism.
# Most likely offenders are /proc/stat and /proc/version.
# If processor count fails, the installer will continue without these,
#   because most programs will still work. Depends on what the user needs.
# Caution: Since these are dummy, anything needing real responses may fail.

count_processors() { # This picks the appropriate size, counting from 0:
	grep cessor /proc/cpuinfo > lpa 2>/dev/null
	cat lpa | sed '/model/d' | sed '/name/d' > lpb
	cat lpb | sed 's/[^0-9]*//g' > lpc
	cat lpc | tr -d '\n' > lpd
	let lastProc="$(cat lpd | tail -c 1)" 2>/dev/null
	[ "$?" -ne 0 ] && processors=-1
	if [[ "$lastProc" =~ ^[3-7]$ ]] ; then
		[ "$lastProc" -le 7 ] && processors=8
		[ "$lastProc" -le 5 ] && processors=6
		[ "$lastProc" -le 3 ] && processors=4
	else
		processors=-1
	fi
	rm -f lpa lpb lpc lpd
	echo "let processors=$processors" >> "$alatermTop/status"
} # End count_processors.
#
create_dummyPS() { # Takes one argument: 4 6 or 8.
	[ "$1" = "-1" ] && return # $processors not 4, 6, or 8.
	cd "$alatermTop/var/binds"
	fc="1111111 1111111 1111111 1111111 1111111 1111111 1111111 0 0 0"
	ff="cpu 4444444 4444444 4444444 4444444 4444444 4444444 4444444 0 0 0"
	fs="cpu 6666666 6666666 6666666 6666666 6666666 6666666 6666666 0 0 0"
	fe="cpu 8888888 8888888 8888888 8888888 8888888 8888888 8888888 0 0 0"
	c4="cpu0 $fc\ncpu1 $fc\ncpu2 $fc\ncpu3 $fc"
	case "$1" in
		4 ) cpu="$ff\n$c4" ;;
		6 ) cpu="$fs\n$c4\ncpu4 $fc\ncpu5 $fc" ;;
		8 ) cpu="$fe\n$c4\ncpu4 $fc\ncpu5 $fc\ncpu6 $fc\ncpu7 $fc" ;;
		* ) return ;; # Did not get a useful result.
	esac
	intr="intr 123456789"
	let n=0
	while [ "$n" -lt 500 ] ; do
		intr+=" 0"
		let n=n+1
	done
	printf "$cpu\n" > dummyPS
	printf "$intr\n" >> dummyPS
	printf "ctxt 1234567890\n" >> dummyPS
	printf "btime 1234567890\n" >> dummyPS
	printf "processes 1234567\n" >> dummyPS
	printf "procs_running 3\n" >> dummyPS
	printf "procs_blocked 0\n" >> dummyPS
	printf "softirq 23456789 12345 1234567 234567 3456 56789 " >> dummyPS
	printf "45678 123456 24680 13579\n" >> dummyPS
} # End create dummyPS.

create_dummyPV() {
	cd "$alatermTop/var/binds"
	cat <<- EOC > dummyPV # Hyphen. Unquoted marker. Single gt.
	Linux version 4.14.15 (user@dummy.example.com)
	(gcc version 8.2.1 20180730 (Android Linux 9.1.1))
	#1 Wed Dec 12 12:34:50 PST 2018
	EOC
} # End create_dummyPV.


# Perform the above functions:
mkdir -p "$alatermTop/var/binds"
count_processors
[ ! -r /proc/stat ] && create_dummyPS "$processors"
[ ! -r /proc/version ] && create_dummyPV
sleep .2
echo -e "$INFO Created dummy binds."
echo "createdBinds=yes" >> "$alatermTop/status"
##
