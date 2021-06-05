#!/bin/bash
set -e 

git submodule update .
DIR="$(realpath $(dirname $0))"
echo "DIR=$DIR"
test -f $DIR/gitstatus/gitstatus.prompt.sh
echo "found gitstatus"
(
	echo '#!/bin/bash'
	echo 'GITSTATUS_DIR="'"$DIR"'/gitstatus/gitstatus.plugin.sh"'
	echo 'source "'"$DIR"'/gitstatus/gitstatus.prompt.sh"'
) > $DIR/src/dot-bashrc-source/gitstatus.sh
echo "created gitstatus.sh"
