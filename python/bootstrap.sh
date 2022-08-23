#!/bin/bash

if [ -z "$CONDA_EXE" ]
then
	CONDA_EXE="$(which conda)"
fi
if [ -f "$CONDA_EXE" ]
then
	CONDA_INSTALL_PATH="${CONDA_EXE%/bin/conda}"
fi

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sed "s#CONDA_INSTALL_PATH#$CONDA_INSTALL_PATH#g"  "$BASE/bashrc_conda_setup.sh" > $HOME/.bashrc-source/conda_setup.sh


