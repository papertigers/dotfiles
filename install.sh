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

iterm2_profile="$PWD/osx/iTerm2"
font_dir="$HOME/.local/share/fonts"
rust_support=false

while true; do
  case "$1" in
    -r | --with-rust-support ) rust_support=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

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
if $rust_support; then
	symlink "$PWD/vim/optional/rust.vim" "$PWD/vim/bundle/rust.vim"
	symlink "$PWD/vim/optional/vim-racer" "$PWD/vim/bundle/vim-racer"
fi

# Link dotfiles
for f in vimrc vim tmux.conf tmuxline.conf; do
	[[ -d ~/.$f ]] && rm -r ~/."$f"
	symlink "$PWD/$f" ~/."$f"
done

# Mac OS X specific
if [[ $(uname) == 'Darwin' ]]; then
	font_dir="$HOME/Library/Fonts"
	if ! brew help &> /dev/null; then
		echo 'installing homebrew'
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo 'updating homebrew'
		brew update
	fi

	brew install the_silver_searcher
	brew install wget
	brew install tmux
fi

# Install custom fonts for powerline
mkdir -p "$font_dir"
echo 'Copying fonts'
cp "fonts/Inconsolata-g for Powerline.otf" "$font_dir"
if command -v fc-cache @>/dev/null ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f $font_dir
fi

# Mac OS X modifications
if defaults read com.apple.finder &>/dev/null; then
	if defaults read com.googlecode.iterm2 &>/dev/null; then
		echo 'modifying iTerm2 preference location'

		# Specify the preferences directory
		defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$iterm2_profile"
		# Tell iTerm2 to use the custom preferences in the directory
		defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
		echo; echo; echo
		echo '---> restart iTerm2 to pick up the new configuration <---'
		echo; echo
	fi
fi
