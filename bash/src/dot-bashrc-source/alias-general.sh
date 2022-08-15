#!/bin/bash

# make rm and mv interactive to avoid unwanted deletion
alias rm="rm -I"  # NB: use `trash` from 'trash-cli' instead to put it into the Desktop-Trash
alias mv="mv -i"
alias cp="cp -i"
# use colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls="ls --color=auto"
alias l="ls --color=auto -lh"
alias la="ls --color=auto -lah"
alias du="du -sh"

alias today="date +%F"
alias now="date +%F_%T"
alias tdir='mkdir tmp_$(today) && cd tmp_$(today)'
alias tdirrm='PWD=$(pwd); test ${PWD%tmp_$(today)} != $(pwd) && cd .. && \rm -r -I tmp_$(today)'
