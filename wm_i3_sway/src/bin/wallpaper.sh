#!/bin/bash

if [ -d /home/johannes/Bilder/wallpapers ]
then
	/usr/bin/nitrogen --random --set-centered --head=0
	/usr/bin/nitrogen --random --set-centered --head=1
else
	nitrogen --restore
fi
