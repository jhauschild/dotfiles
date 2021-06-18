#!/bin/bash
set -e 
echo "bootstrap for git installation"

git submodule update .

DIR="$(realpath $(dirname $0))"
echo "DIR=$DIR"
test -d $DIR/src/dot-bashrc-source  || mkdir $DIR/src/dot-bashrc-source
if [ -f $DIR/gitstatus/gitstatus.prompt.sh ]
then
	echo "found gitstatus"
	(
		echo '#!/bin/bash'
		echo 'GITSTATUS_DIR="'"$DIR"'/gitstatus/gitstatus.plugin.sh"'
		echo 'source "'"$DIR"'/gitstatus/gitstatus.prompt.sh"'
	) > $DIR/src/dot-bashrc-source/gitstatus.sh
	echo "created gitstatus.sh"
fi

