# Alaterm:file=$alatermTop/home/.bashrc
# File /home/.bashrc created by Alaterm installer.

# Most initialization is in /etc/profile  or ~/.bash_profile.
# But do not edit those files unless absolutely necessary.
# If adding custom commands, do it at the bottom of this file.

# This file is sourced at user login, immediately after ~/.bash_profile.
# It is also sourced if you use su to root, then exit to return to user.

# Command prompt:
export PS1='\e[1;38;5;75m[alaterm:user@\W]$ \e[0m'
alias ls='/usr/bin/ls --color=auto' # pretty-prints directory lists.
alias pacman='sudo pacman'
alias fc-cache='sudo fc-cache'
# The installed vncviewer executable is ineffective:
alias vncviewer='echo -e "\e[33mUse the separate VNC Viewer app.\e[0m"'
## If you have any custom ~/.bashrc code, put it below:



##
