#!/bin/bash

set -e

source ../python/src/dot-bashrc-source/conda_setup.sh

if conda env list | grep neovim-py3 
then
	echo "neovim env already found"
else
	conda env create -f environment_py3.yml
	#conda env create -f environment_py2.yml
fi

conda activate neovim-py3
FROM="$HOME/bin/nvr"
TARGET="$(which nvr)"
if [ \( ! -e "$FROM" \) -a -x "$(which nvr)" -a "$(which nvr)" != "$FROM" ]
then
	echo "create link for nvr"
	ln -s $(which nvr) "$FROM"
fi
conda deactivate


DIR="$(realpath $(dirname $0))"
if [ -e "$HOME/.config/nvim" -o -L "$HOME/.config/nvim" ]
then
	echo "~/config/nvim already exists"
else
	echo "link .config/nvim"
	ln -s -r $DIR/nvim $HOME/.config/nvim
fi

