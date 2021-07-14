contains() {  # arguments: string, substring
    # return true==0 if $2 is substring of $1
    # note: returns False if $2 is empty
    # implemented with pure POSIX bash: try to remove *$2 from the beginning
    if [ "${1#*$2}" != "$1" ]
    then
        return 0  # $2 is part of $1
    else
        return 1
    fi
}

# set library paths if not done before
add_path() { 
    # takes two sarguments, one variable_name,e.g. 'PYTHONPATH', and one directory, e.g. $HOME/some/path
    # appends $2 to the variable given by $1 (adding ':' inbetween, if necessary) and exports $1
    # a third argument $3 can optionally be 'first' to indicate that the new path should be added as first entry.
    # NOTE: adds $2 only if $2 is a valid directory
    if [ -d "$2" ]
    then
        VAL1="$(eval echo \$$1)"
        if [ -n "$VAL1" -a -n "$2" ]
        then
            if ! contains "$VAL1" "$2"
            then
                if [ "$3" = "first" ]
                then
                    export $1="$2:$VAL1"
                else
                    export $1="$VAL1:$2"
                fi
            fi
        else
            export $1="$VAL1$2"
        fi
    else 
         echo "add_path: not valid directory: $2" 1>&2
    fi
}

test -d "$HOME/.local/bin" && add_path 'PATH' "$HOME/.local/bin" first
add_path 'PATH' "$HOME/bin" first

