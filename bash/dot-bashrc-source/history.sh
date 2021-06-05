shopt -s histappend
PROMPT_COMMAND="history -an; $PROMPT_COMMAND"
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT='%Y-%m-%d '
export HISTIGNORE="ls:l:pwd:exit:cd"
export HISTCONTROL=ignorespace
