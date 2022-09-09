#!/bin/bash
# written by Johannes Hauschild, MIT LICENSE

# usage: add the following two lines in your ~/.bashrc:
SSH_AUTH_SOCK_LINK="$HOME/.ssh-auth-sock"
test -z "$SSH_AUTH_SOCK" && export SSH_AUTH_SOCK=$SSH_AUTH_SOCK_LINK

ssh-auto-add () {
    ssh-add -l &> /dev/null
    # `ssh-add -l` exit codes: 0=has keys, 1=no keys, 2=socket invalid
    if [[ $? == 2 ]]
    then
        local LIVE_SOCKET=""
        # look for a running ssh agent
        for SOCKET in $(find /tmp/ -type s -user $USER -name agent.\* 2> /dev/null | grep '/tmp/ssh-.*/agent.*')
        do
            SSH_AUTH_SOCK="$SOCKET" ssh-add -l &> /dev/null
            if [[ $? != 2 ]]
            then
                LIVE_SOCKET="$SOCKET"
                break
            fi
        done
        if [[ -S "$LIVE_SOCKET" ]]
        then
            echo "found working socket: $LIVE_SOCKET"
            SSH_AUTH_SOCK="$LIVE_SOCKET"
        else
            echo "found no working socket, start a new ssh-agent"
            eval "$(ssh-agent -t 43200 -s)"  # 12 hours...
        fi
    fi
    # should have a working SSH_AUTH_SOCK now...
    if [[ ! -S "$SSH_AUTH_SOCK_LINK" ]]
    then
        echo "use $SSH_AUTH_SOCK as $SSH_AUTH_SOCK_LINK"
        test -L "$SSH_AUTH_SOCK_LINK" && /usr/bin/rm "$SSH_AUTH_SOCK_LINK"
        ln -s "$SSH_AUTH_SOCK" "$SSH_AUTH_SOCK_LINK"
    fi
    export SSH_AUTH_SOCK
    ssh-add -l &> /dev/null
    if [[ "$?" == 1 ]]
    then
        echo "found no keys: call ssh-add"
        export SSH_ASKPASS="_get_ssh_passphrase"  # directly ask my password manager
        ssh-add < /dev/null
    fi
}
