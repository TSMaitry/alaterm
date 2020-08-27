# Alaterm:file=$alatermTop/etc/profile
# This TEMPORARY /etc/profile will be replaced by Alaterm installer.

umask 022
appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}
appendpath '/usr/local/scripts'
appendpath '/usr/local/sbin'
appendpath '/usr/local/bin'
appendpath '/usr/bin'
unset -f appendpath
export PATH
if test -d /etc/profile.d/; then
	for profile in /etc/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi
# Alaterm version 2 does not use bash.bashrc.
unset TERMCAP
unset MANPATH
##
source /status # Defines $alatermTop and many other variables.
alias pacman='sudo pacman'
export PS1='tempUser$ '
export DISPLAY=:1
# Most of these also install dependencies, to the actual list is longer:
getThese="nano wget python python-xdg ghostscript ttf-roboto"
getThese+=" tigervnc lxde evince poppler-data poppler-glib freeglut man"
getThese+=" xterm gpicview netsurf leafpad geany geany-plugins ghex libraw"
getThese+=" gnome-calculator gnome-font-viewer libwmf openexr openjpeg2"
getThese+=" thunar thunar-media-tags-plugin"
pacman -Ss -q trash-cli >/dev/null # In case this package is unavailable.
if [ "$?" -eq 0 ] ; then
	getThese+=" trash-cli"
fi
if [ "$gotLXDE" != "yes" ] ; then
	echo -e "$INFO Downloading new packages for LXDE Desktop..."
	pacman -Sq --noconfirm --needed $getThese # No quotes.
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Could not download LXDE packages."
		echo "Bad Internet connection, or server is down."
		echo "Wait awhile and try again."
		logout # Will be detected as error by main installer script.
	else
		sleep .5
		echo -e "$INFO Completed install new Arch packages."
		echo "gotLXDE=yes" >> /status
	fi
fi
sleep .5
# Program lxmusic comes with Arch, but is non-working in Alaterm. Remove it:
pacman -Rsc lxmusic --noconfirm >/dev/null 2>&1
# This VNC password is:  password
echo -e -n "\xDB\xD8\x3C\xFD\x72\x7A\x14\x58" > /home/.vnc/passwd
chmod 600 /home/.vnc/passwd
echo "configuredVnc=yes" >> /status
sleep 0.2
# When this routine logs out, the main installer script looks for
# configuredVnc in the status file. If there, good.
# If not, the main script knows that this routine failed, so it exits.
logout # Success. Returns to installer script.
# Note that files such as .bash_login and .bashrc are not read.
##
