#!/bin/bash

# gsettings set org.gnome.mutter.keybindings switch-monitor "['<Super>s']"

dconf load /org/gnome/ < ./org_gnome.dconf  

