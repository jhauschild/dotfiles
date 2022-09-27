#!/bin/bash

if pgrep polybar 
then
	killall polybar
fi

for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload bottom &
done
