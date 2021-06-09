
#type module &> /dev/null
#if [ "$?" -eq 1 ] # -a -n "$(which modulecmd)" ]
#then
#    # define the module function by hand to invoke $HOME/bin/modulecmd
#    module () {
#        eval $(modulecmd bash "$@")
#    }
#fi

add_path 'MODULEPATH' $HOME/.modulefiles

