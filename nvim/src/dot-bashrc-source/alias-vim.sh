#!/bin/bash

alias vi="command vim --clean"
alias vim="nvim"
alias gvim="nvim-wrapper"

test -x "$(which nvim)" && export EDITOR="nvim"
