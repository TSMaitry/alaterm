# Alaterm:file=$alatermTop/etc/profile
# This TEMPORARY /etc/profile will be re-created during Alaterm install.

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
export PS1='tempRoot# '
# Generate locale:
if [ "$localeGenerated" != "yes" ] ; then
	printf "$INFO " && locale-gen
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Could not use locale-gen."
		logout # Returns to main script, throws error.
	else
		chmod 644 /etc/environment
		chmod 644 /etc/locale.conf
		echo "localeGenerated=yes" >> /status
	fi
fi
# Blank-out Arch messages:
echo "" > /etc/moto && chmod 644 /etc/moto
echo "" > /etc/motd && chmod 644 /etc/motd
# Arch comes with a pre-defined user named alarm.
# Not useful in Alaterm. Delete alarm:
cd /home
[ -d alarm ] && chmod 777 alarm
rm -r -f alarm 2>/dev/null
cd /root # Must be outside home now.
userdel alarm 2>/dev/null
udelcode="$?"
case "$udelcode" in
	0 )	echo -e "$INFO Deleted default alarm user." ;;
	6 )	echo -e "$INFO Default alarm user already deleted." ;;
	* )	echo -e "$PROBLEM Could not execute userdel."
		logout ;; # Will be seen as error by main script.
esac
# Add new Alaterm user, home is /home without sub-directory:
# stackoverflow.com q. 2150882 answer by Damien:
useradd -M -d /home -p $(openssl passwd -1 password) user 2>/dev/null
uaddcode="$?"
case "$uaddcode" in
	0 )	echo -e "$INFO Added new user." ;;
	9 )	echo -e "$INFO New user already added." ;;
	* )	echo -e "$PROBLEM Could not execute useradd or openssl."
		logout ;; # Will be seen as error by main script.
esac
# Arch comes with a default server name that is wrong for Alaterm. Fix it:
echo "localhost" > /etc/hostname 2>/dev/null # Over-writes existing.
# Initialize pacman package manager:
if [ "$pacmanPopulated" != "yes" ] ; then
	sleep .5
	pacman-key --init && pacman-key --populate archlinuxarm
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Failed to initialize pacman."
		logout # Returns to main script, throws error.
	fi
	echo -e "$INFO Initialized pacman package manager."
	echo "pacmanPopulated=yes" >> /status
fi
# Arch in proot cannot compile kernel modules. Uses Android kernel.
# So, remove packages used for modifying kernel:
if [ "$removedUseless" != "yes" ] ; then
	pacman -Rc $yourDelete --noconfirm >/dev/null 2>&1
	if [ "$?" -ne 0 ] ; then
		echo -e "$WARNING Incorrect kernel package list:"
		echo "  $yourDelete"
		echo "  Until correct list is removed using pacman,"
		echo "  your installation may have problems."
	else
		echo -e "$INFO Deleted packages irrelevant in proot."
	fi
	sleep .5
	pacman -Qdtq | pacman -Rc - --noconfirm >/dev/null 2>&1 # Autoremove.
	sleep .5
	pacman -Qdtq | pacman -Rc - --noconfirm >/dev/null 2>&1 # Yes, again.
	sleep .5
	sed -i "s/^#IgnorePkg.*/IgnorePkg = $yourDelete /g" /etc/pacman.conf
	sleep .2
	rm -r -f /boot
	rm -r -f /usr/lib/firmware
	rm -r -f /usr/lib/modules
	echo "removedUseless=yes" >> /status
fi
# Upgrade the stuff that was delivered in Arch archive:
if [ "$upgradedArch" != "yes" ] ; then
	echo -e "$INFO Upgrading installed packages..."
	pacman -Syuq --noconfirm
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Could not perform upgrade."
		echo "Most likely lost Internet connection."
		echo "Or perhaps file server is temporarily down."
		echo "Try again, after awhile."
		logout # Returns to main script, throws error.
	else
		echo -e "$INFO Upgrade complete."
	fi
	echo "upgradedArch=yes" >> /status
fi
# Install sudo, so that ordinary user will be able to run pacman:
if [ "$gotSudo" != "yes" ] ; then
	pacman -Sq --noconfirm sudo
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Failed to install sudo."
		echo "Most likely lost Internet connection."
		echo "Or perhaps file server is temporarily down."
		echo "Try again, after awhile."
		logout # Returns to main script, throws error.
	else
		echo -e "$INFO Installed sudo."
	fi
	# Add user to sudoers, automatic password=password :
	sleep .2
	cd /etc
	chmod 660 sudoers
	echo "Defaults lecture=\"never\"" >> sudoers
	echo "Defaults targetpw" >> sudoers
	echo -e "user ALL=\x28ALL\x29 NOPASSWD: ALL" >> sudoers
	chmod 440 sudoers
	echo "Set disable_coredump false" >> sudo.conf
	chmod 640 sudo.conf
	echo "gotSudo=yes" >> /status # Not recorded if not yes.
fi
sleep .5
logout # Success. Returns to main script, no error.
# Note that files such as .bash_login and .bashrc are not read.
# After any exit, process returns to main installer script.
# If everything above completed successfully, then gotSudo is now in /status.
# So the main script will perform: grep gotSudo /status
# then continue or exit, depending on result.
##
