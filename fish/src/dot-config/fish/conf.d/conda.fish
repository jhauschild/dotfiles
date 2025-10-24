if [ -x "/opt/micromamba/bin/micromamba" ] 
	# >>> mamba initialize >>>
	# !! Contents within this block are managed by 'micromamba shell init' !!
	set -gx MAMBA_EXE "/opt/micromamba/bin/micromamba"
	set -gx MAMBA_ROOT_PREFIX "/opt/micromamba"
	$MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
	# <<< mamba initialize <<<
	abbr -a co --position command micromamba
end

