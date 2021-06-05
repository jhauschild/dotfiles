# My Dotfiles

Like [many others](https://dotfiles.github.io), I like tweeking configurations to suit my needs.

While many people just have all their dotfiles scattered among different folders in a single repository, here we aim to organize them by topics.
This is very much inspired by [holman's dotfiles](https://github.com/holman/dotfiles).


## Structure
Each folder represents one topic to which the dotfiles belong.
Note that a subfolder for a topic might also be another git repository in the form of a git submodule, in my case for example the dotfiles-private (which you shouldn't have access to...), but you can also use repos for vim-configs etc.

Each of these `topic` folders can contains files in a `src` folder, which are to be included into `$HOME/` as symlinks. 
We replacing "dot-" with a single dot, e.g., `dot-bashrc` -> `.bashrc`.
Some files within a topic are special:

- `bootstrap.sh`
	An optional script that should be called for installation before generating the symlinks.
	This can be used to download files into the repo, initialize git submodules or similar things.
- `install.sh`
	Install script. If existent, this script is called instead of creating symlinks for everything.
- `include`, `exclude`
	If no `install.sh` script exists, the global `install.sh` script just creates symlinks for each of the files in the topic's `src/` folder.
	If `include` is present, it defines pattern filters which files should be "included" to be symlinked (excluding anything not matched).
	A `exclude` can define filters what is to be excluded.
	Those files should have one pattern per line (dropping `#` and anything following it to allow comments, but not the space before!).
	Further, some exclude-patterns are hard-coded in the function `find_files_excluding` of the (global) `install.sh` script.

The `~/.bashrc` provided in the `bash` topic automatically sources any file in the folder `~/.bashrc-source`.
In that way, other topics can choose to add content to the `~/.bashrc` without overwriting it.
