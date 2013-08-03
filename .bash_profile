# /etc/skel/.bash_profile

if [[ ! $GNOME_KEYRING_PID ]]; then
#    export $(gnome-keyring-daemon --daemonize --start)
    export $(gnome-keyring-daemon --start)
fi


# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc
