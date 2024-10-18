#!/bin/bash
# exports all conda envs into .yml files
# to import again, call
#     conda env create -f my_env.yml
# or in a loop
#     for ENV_FILE in $(ls *.yml) ; do ; conda env create -f $ENV_FILE ; done
. ~/.bashrc-source/conda_setup.sh

CONDAEXE=mamba

for ENV in $($CONDAEXE env list | grep -v "^#" | cut -f 1 -d ' ')
do
	$CONDAEXE activate $ENV
	$CONDAEXE env export > $ENV.yml
	$CONDAEXE deactivate
done
