#!/usr/bin/bash

if [ $# == 0 ]
then
	echo -e "lock"
	echo -e "logout"
	echo -e "suspend"
	echo -e "hibernate"
	echo -e "shutdown"
	echo -e "reboot"
	echo -e "abort"
	exit 0
fi



case $1 in 
abort) exit 0;;
lock) 
    if  [[ -n "$WAYLAND_DISPLAY" ]] ; then
        swaylock -c 000000
    else
        loginctl lock-session
    fi
    ;;
logout) 
    if  [[ -n "$WAYLAND_DISPLAY" ]] ; then
        swaymsg exit
    else
        i3-msg exit
    fi
     ;;
suspend)  systemctl suspend ;;
hibernate)  systemctl hibernate ;;
shutdown) systemctl poweroff ;;
reboot) systemctl reboot ;;
*) echo "invalid command"
exit 1;;
esac
