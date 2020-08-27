# Alaterm:file=$alatermTop/root/.bashrc
# File /root/.bashrc, created by Alaterm installer.

# Normally, this file is read only when you su to switch from user to root.
# Note that root is for Alaterm. It does not reach to Android root.
# But root is almost never needed. Hint: Its password is root.

# If you hack the installation to create root login [not advised],
# then this file would be read immediately after /root/bash_profile.

# Normally, you should not modify this file.
# If you do, put your custom commands at the bottom.

rm -f /root/.bash_history
# Command prompt:
export PS1='\e[1;38;5;75m[alaterm:root@\W]# \e[0m'
# Lecture, once per session. Uses marker file /root/.lectured-root:
if [ ! -f /root/.lectured-root ] ; then
        echo -e "\e[33mOnly use root if necessary."
        echo -e "Root is in Alaterm, not Android."
        echo -e "Programs using the GUI cannot be launched from root."
        echo -e "To leave root and return to ordinary Alaterm user: exit\e[0m"
        touch /root/.lectured-root
fi
# Ensure that su from root returns to user:
alias su='rm -f /root/.lectured-root && exit'
## Your custom commands for root, if any, go below.


##
