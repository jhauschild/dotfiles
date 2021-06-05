#export PS1='\[\e[94m\]\w\[\e[0m\] ${GITSTATUS_PROMPT}\n \[\e[32m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\]> '

PS1='(\[\033[01;33m\]$CONDA_DEFAULT_ENV\[\033[00m\]) '                         # yellow conda environment
PS1+='\[\033[01;34m\]\w\[\033[00m\]'                                           # blue current working directory
PS1+='${GITSTATUS_PROMPT:+ $GITSTATUS_PROMPT}\n'                               # git status (requires promptvars option)
PS1+='\[\033[32m\]\u\[\033[00m\]@\[\033[32m\]\h\[\033[00m\] '            # green user@host
PS1+='\[\033[01;$((31+!$?))m\]\$\[\033[00m\] '    # green/red (success/error) $/# (normal/root)
#PS1+='\[\e]0;\u@\h: \w\a\]'                         # terminal title: user@host: dir
