#!/usr/bin/bash

# based on https://git.zx2c4.com/password-store/tree/contrib/dmenu/passmenu
# extended by JHauschild to use rofi instead
# use as `rofi -matching fuzzy -show pass -modi "pass:~/.config/rofi/scripts/pass.sh"`
# `rofi -matching fuzzy -show pass -modi "pass:~/.config/rofi/scripts/pass.sh --type"`


shopt -s nullglob globstar

typeit=0
if [[ $1 == "--type" ]]; then
	typeit=1
	shift
fi


if [[ -z "$1" ]]; then
	prefix=${PASSWORD_STORE_DIR-~/.password-store}
	password_files=( "$prefix"/**/*.gpg )
	password_files=( "${password_files[@]#"$prefix"/}" )
	password_files=( "${password_files[@]%.gpg}" )
	# rofi calls script once without args to get options
	printf '%s\n' "${password_files[@]}"
	exit 0  
fi 
# and second time with selection
password="$1"

[[ -n "$password" ]] || exit 0

if  [[ -n "$WAYLAND_DISPLAY" ]] ; then
TYPE="wtype"
else
TYPE="xdotool type --clearmodifiers --file "
fi
if [[ "$GPG_TTY" == "not a tty" ]] ; then
export "GPG_TTY=/dev/pts/0"
fi

if [[ $typeit -eq 0 ]]; then
	coproc ( pass show -c "$password" &>/dev/null )
else
	coproc ( pass show "$password" | { IFS= read -r pass; printf %s "$pass"; } | $TYPE -  )
fi
exit 0
