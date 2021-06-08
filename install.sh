#!/bin/bash

set -e # exit on error

REPO="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SKIPALL=false
REPLACEALL=false
BACKUPALL=false
DRYRUN=false

link_file () {
	local TARGET="$1" LINKNAME="$2"
	if [ "$DRYRUN" == true ]
	then
		echo "link $LINKNAME -> $TARGET"
		return 0
	fi
	# create a link at $LINKNAME pointing to $TARGET
	# if $LINKNAME exists, ask whether to replace, backup or skip, with the option to do that for all following existing links
	local REPLACE= BACKUP= SKIP= CHOICE=
	local QUERY=true
	if [ -f "$LINKNAME" -o -d "$LINKNAME" -o -L "$LINKNAME" ]
	then
		if [ "$(readlink -m $LINKNAME)" == "$(readlink -m $TARGET)" ]
		then
			SKIP="true"
		else
			if [ "$REPLACEALL" != "true" -a "$BACKUPALL" != "true" -a "$SKIPALL" != "true" ]
			then
				echo "trying to create link from $LINKNAME to ${TARGET}"
				echo "but $LINKNAME already exists!"
				while [ "$QUERY" == "true" ]
				do
					echo -n "Choose: [s]kip, [S]kip all, [r]eplace, [R]eplace all, [b]ackup, [B]ackup all? "
					read -n 1 CHOICE
					echo ""  # newline
					case "$CHOICE" in
						r )
							QUERY=false
							REPLACE=true;;
						R )
							QUERY=false
							REPLACEALL=true;;
						b )
							QUERY=false
							BACKUP=true;;
						B )
							QUERY=false
							BACKUPALL=true;;
						s )
							QUERY=false
							SKIP=true;;
						S )
							QUERY=false
							SKIPALL=true;;
						* )
							echo -e "Didn't understand that."
					esac
				done
			fi
		fi
		REPLACE=${REPLACE:-$REPLACEALL}
		BACKUP=${BACKUP:-$BACKUPALL}
		SKIP=${SKIP:-$SKIPALL}
		if [ "$BACKUP" == "true" ]
		then
			echo "backup $LINKNAME.backup"
			mv "$LINKNAME" "$LINKNAME.backup"
		elif [ "$REPLACE" == "true" ]
		then
		  rm -rf "$LINKNAME"
		  echo "removed $LINKNAME"
		fi
	fi
	if [ "$SKIP" == "true" ]
	then
		echo "skip $TARGET"
	else  # SKIP is empty or "false"
		echo "link from $LINKNAME to $TARGET"
		ln -s -r "$TARGET" "$LINKNAME"
	fi
}


find_files () {
	# find all files *not* matching any pattern given in the file $1
	# with hard-coded exclusions below
	local INCLUDEFILE="$1"
	local EXCLUDEFILE="$2"
	local PATTERN
	#  hard-coded excludes (as arguments to `find`)
	set -- -name ".*"
	# 'set --' sets the argument list to whatever follows, used later as "$@".
	if [ -n "$EXCLUDEFILE" -a -f "$EXCLUDEFILE" ]
	then
		while IFS= read -r PATTERN
		do
			PATTERN="${PATTERN%#*}" # remove any comments starting with #
			if [ -n "$PATTERN" ]
			then
				set -- "$@" -o -name "$PATTERN"
			fi
		done < "$EXCLUDEFILE"
	fi
	set -- -not \( "$@" \)
	if [ -n "$INCLUDEFILE" -a -f "$INCLUDEFILE" ]
	then
		local HASCONTENT=false
		while IFS= read -r PATTERN
		do
			if [ -n "${PATTERN%#*}" ]
			then
				HASCONTENT=true
			fi
		done < "$INCLUDEFILE"
		if [ "$HASCONTENT" == true ]
		then
			set -- \) "$@"
			while IFS= read -r PATTERN
			do
				PATTERN="${PATTERN%#*}" # remove any comments starting with #
				if [ -n "$PATTERN" ]
				then
					set -- -o -name "$PATTERN" "$@"
				fi
			done < "$INCLUDEFILE"
			shift   # remove -o at beginnging
			set -- \( "$@"
		fi
	fi
	find src -mindepth 1 \( -type f -o -type l \) "$@"
}

install_topic () {
	# call bootstrap script and 
	# symlink all the files from the current folder into ~/
	if [ -x ./bootstrap.sh ]
	then
		echo "call bootstrap script"
		./bootstrap.sh
	fi
	if [ -x ./install.sh ]
	then
		./install.sh
	else
		# default installation: create symlinks
		for TARGET in $(find_files "./include" "./exclude")
		do
			FROM="${TARGET#src/}"
			FROM="${FROM/dot-/.}"
			link_file "$TARGET" "$HOME/$FROM"
		done
	fi
}


parse_args () {
	while [[ "$1" =~ ^- ]]
	do
		case "$1" in
		-h | --help )
			echo "$0 [-h] [-n] topic [topic ...]"
			echo "Install the given 'topic' folders."
			echo "-h, --help: display this help and exit"
			echo "-n, --dry-run:  don't do something, only display what would be done."
			exit
			;;
		-n | --dry-run )
			DRYRUN=true
			;;
		esac
		shift
	done
	if [ $# == 0 ]
	then
		set -- "$(find .  -mindepth 1 -type d -not -name ".*")"
	fi
	for TOPIC in "$@"
	do 
		cd "$REPO"
		echo "================================================================================"
		echo "TOPIC=$TOPIC"
		echo "================================================================================"
		cd "$TOPIC"
		install_topic "$TOPIC"
	done
}

parse_args "$@"

# TODO: uninstall?
