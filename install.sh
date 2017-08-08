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

iterm2_plist_path="~/Library/Preferences/com.googlecode.iterm2.plist"

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

# Mac OS X specific
if [[ $(uname) == 'Darwin' ]]; then
	if ! brew help &> /dev/null; then
		echo 'installing homebrew'
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo 'updating homebrew'
		brew update
	fi

	brew install the_silver_searcher
	brew install wget

	# This doesn't work yet
	# iTerm2 preferences
	#[[ -f $iterm2_plist_path ]] && rm "$iterm2_plist_path"
	#symlink "$PWD/osx/iTerm2/com.googlecode.iterm2.plist" "$iterm2_plist_path"
fi
