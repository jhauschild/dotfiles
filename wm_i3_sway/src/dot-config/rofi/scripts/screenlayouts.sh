#!/usr/bin/bash

if [ $# == 0 ]
then
	cd ~/.screenlayout
	for f in $(ls)
	do
		echo $f
	done
	exit 0
fi

bash ~/.screenlayout/no-external-$HOSTNAME.sh
bash ~/.screenlayout/$1
