#!/bin/bash

sleep 1

if pgrep polybar 
then
	killall polybar
fi

sleep 1

for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload bottom &
done
