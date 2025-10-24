function fish_prompt --description 'Write out the prompt'
    set -g CMD_LAST_STATUS $status
    set -l normal (set_color normal)
    set -l status_color (set_color green)
    set -l env_color (set_color yellow)
    set -l cwd_color (set_color $fish_color_cwd)
    set -l git_color (set_color brgreen)
    set -l prompt_status ""

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    # Color the prompt differently when we're root
    set -l suffix '❯'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set cwd_color (set_color $fish_color_cwd_root)
        end
        set suffix '#'
    end

    # Color the prompt in red on error
    if test $CMD_LAST_STATUS -ne 0
        set status_color (set_color $fish_color_error)
        # set prompt_status $status_color "[" $last_status "]"
    end

    echo -s '(' $env_color $CONDA_DEFAULT_ENV $normal ') ' $cwd_color (prompt_pwd) $git_color (fish_git_prompt) $normal 
    echo -n -s (prompt_login) ' ' $status_color $suffix ' ' $normal
end

function fish_right_prompt --description 'right prompt'
    set -l status_color (set_color green)
    set -l normal (set_color normal)
    set -l runtime ''
    if [ $CMD_LAST_STATUS -ne 0 ]
        set status_color (set_color $fish_color_error)
    end
    
    set runtime (printf '%02.0f.%03d' (math $CMD_DURATION / 1000) (math $CMD_DURATION % 1000))
    if [ $CMD_DURATION -gt 60000 ]
        set runtime (printf '%02.0f:%s' (math $CMD_DURATION / 60000) $runtime)
        if [ $CMD_DURATION -gt 3600000 ]
            set runtime (printf '%02.0f:%s' (math $CMD_DURATION / 3600000) $runtime)
        end
    end
    printf "%s[%s %s%s%s]%s" $status_color $CMD_LAST_STATUS $normal $runtime $status_color $normal
end
