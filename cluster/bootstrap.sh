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
  test -x ~/.bashrc-interactive && source ~/.bashrc-interactive
fi
EOF
	else
		echo "Skip: no hostname pattern given."
	fi
fi
