#!/usr/bin/env bash
#
# install all files to ~ by symlinking them,
# this way, updating them is as simple as git pull
#
# Author: Dave Eddy <dave@daveeddy.com>
# Date: May 25, 2012
# License: MIT
#
# Modified: Mike Zeller <mike@mikezeller.net>

# makes "defaults" command print to screen
defaults() {
	echo defaults "$@"
	command defaults "$@"
}

# verbose ln, because `ln -v` is not portable
symlink() {
	printf '%40s -> %s\n' "${1/#$HOME/~}" "${2/#$HOME/~}"
	ln -sf "$@"
}

git submodule init
git submodule update

# Link dotfiles
for f in vimrc vim; do
	[[ -d ~/.$f ]] && rm -r ~/."$f"
	symlink "$PWD/$f" ~/."$f"
done
