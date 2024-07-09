#!/bin/bash

if ! type brew &>/dev/null; then
    echo -e "\n\n\n\n Installing Homebrew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >>$HOME/.zprofile
    eval $(/opt/homebrew/bin/brew shellenv)
fi

echo -e "\n\nInstalling git and terminal customization tools..."
brew install -q git tig zsh zsh-completions
