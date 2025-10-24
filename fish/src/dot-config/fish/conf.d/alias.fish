#!/usr/bin/fish

function today
	date +%F
end
function now
	date +%F_%T
end

function tdir
	mkdir tmp_(today) && cd tmp_(today)
end
function tdirrm
	set dir "$(basename (pwd))"
	if string match 'tmp_*' "$dir"
		cd ..
		command rm -rf "$dir"
	end
end

function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

abbr -a rm --position command rm -I
abbr -a mv --position command mv -i
abbr -a cp --position command cp -i
abbr -a du --position command du -sh
abbr -a conda --position command micromamba
abbr -a coa --position command micromamba activate

abbr -a p --position command python
abbr -a p3 --position command python3
abbr -a jy --position command jupyter 
abbr -a jl --position command jupyter lab

abbr -a vim --position command nvim

abbr -a o --position command xdg-open

