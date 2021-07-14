#!/bin/bash

if [ -L ~/.bashrc ]
then
	read -p "Enter hostname pattern for login nodes (empty=skip): " PATTERN
	if [ -n "$PATTERN" ]
	then
		echo "create wrapper .bashrc for login nodes"
		mv ~/.bashrc ~/.bashrc-interactive
cat << EOF  > ~/.bashrc
if [[ "\$HOSTNAME" == $PATTERN ]] 
then
	if [ -f ~/.bashrc-interactive ]
	then
		source ~/.bashrc-interactive
	fi
else
	if [ -f /etc/.bashrc ]
	then
		source /etc/.bashrc
	fi
	if [ -f ~/.bashrc-source/aaa_paths.sh ]
	then
		source ~/.bashrc-source/aaa_paths.sh
		add_path 'MODULEPATH' "\$HOME/.modulefiles"
	fi
fi
EOF
	else
		echo "Skip: no hostname pattern given."
	fi
fi
