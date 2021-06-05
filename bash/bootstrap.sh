#!/bin/bash

BASHRCSOURCEDIR="$HOME/.bashrc-source"
if [ ! -d "$BASHRCSOURCEDIR" ]
then
	mkdir "$BASHRCSOURCEDIR"
	# provide a little bit more security: 
	# don't give other users write-right to a folder where you execute each script upon login...
	chmod go-wx "$BASHRCSOURCEDIR"
fi
