#!/usr/bin/fish

if [ -z "$GPG_TTY" ]
	set -gx GPG_TTY (tty)
end
set -g fish_key_bindings fish_hybrid_key_bindings

