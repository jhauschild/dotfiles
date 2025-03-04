#!/usr/bin/bash

ANS="$(wofi -d -p power-menu <<EOF
lock
disable-idle-lock
enable-idle-lock
logout
suspend
hibernate
shutdown
reboot
abort
EOF
)"

if [ -z "$ANS" ]
then
	exit 0
fi


case $ANS in 
abort) exit 0;;
lock)
    loginctl lock-session
    ;;
disable-idle-lock)
    gsettings set org.gnome.desktop.session idle-delay "uint32 0"
    dconf load /org/gnome/settings-daemon/plugins/  <<_EOF
[/]
ambient-enabled=false
idle-dim=false
power-button-action='suspend'
power-saver-profile-on-low-battery=true
sleep-inactive-ac-timeout=7200
sleep-inactive-ac-type='nothing'
sleep-inactive-battery-timeout=7200
sleep-inactive-battery-type='nothing'
_EOF
    ;;
enable-idle-lock)
    gsettings set org.gnome.desktop.session idle-delay "uint32 600"
    dconf load /org/gnome/settings-daemon/plugins/  <<_EOF
[/]
ambient-enabled=true
idle-dim=true
power-button-action='suspend'
power-saver-profile-on-low-battery=true
sleep-inactive-ac-timeout=900
sleep-inactive-ac-type='suspend'
sleep-inactive-battery-timeout=1200
sleep-inactive-battery-type='nothing'
_EOF
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
