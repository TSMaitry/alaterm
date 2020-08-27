# Alaterm:file=$alatermTop/etc/profile
# File /etc/profile edited by Alaterm installer.

umask 022 # Termux settings may over-ride this.
# Default paths:
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
# Load profiles from /etc/profile.d:
if [ -d /etc/profile.d/ ] ; then
	for profile in /etc/profile.d/*.sh ; do
		[ -r "$profile" ] && source "$profile"
	done
	unset profile
fi
unset TERMCAP
unset MANPATH
# Alaterm version 2 does not use /etc/bash.bashrc.
# File /home/.bash_profile is read next.
##
