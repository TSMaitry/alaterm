# Alaterm:file=$alatermTop/root/.bash_profile
# File /root/bash_profile, created by Alaterm installer.

# Alaterm uses only BASH as its shell.

# Unless you hack the installation, this file is never read,
# because you do not login as root before automatically switching to user.
# If you do hack the system to create root login [not advised],
# then this file would be read immediately after /etc/profile,
# because Alaterm version 2 does not use /etc/bash.bashrc.

source /status
# Ensure that /root/.bashrc is sourced, whether login or non-login:
[ -f /root/.bashrc ] && source /root/.bashrc
##
