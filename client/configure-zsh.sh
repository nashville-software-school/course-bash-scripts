#!/bin/bash

current_shell=$(echo $SHELL)
if [ $current_shell == "/bin/bash" ]; then
  echo -e "\n\n\n"
  echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  echo "@@                                                        @@"
  echo "@@   Change Needed: Switch to zsh                         @@"
  echo "@@   This change might require your computer password.    @@"
  echo "@@                                                        @@"
  echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  ZSH_PATH=$(which zsh >>/dev/null)
  if [ $? != 0 ]; then
    echo "ERROR: zsh not found. Skipping chsh"
  else
    SWITCHED=$(chsh -s $ZSH_PATH >>/dev/null)
    if [ $? != 0 ]; then
      echo "ERROR: Could not chsh to zsh"
    else
      new_shell=$(echo $SHELL)
      if [ $new_shell != "$ZSH_PATH" ]; then
        # The rest of the installs will not work if zsh is not the default shell
        echo "ERROR: Shell did not change to zsh."
        exit 1
      fi
    fi
  fi

else
  echo "Already using zsh as default shell"
fi

ZSH_FOLDER=$HOME/.oh-my-zsh
if [ ! -d "$FOLDER" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if grep -q "(zsh-autosuggestions zsh-syntax-highlighting" ~/.zshrc; then
  echo "Text already exists"
else
  sed -i'.original' 's#^plugins=(#plugins=(zsh-autosuggestions zsh-syntax-highlighting #' $HOME/.zshrc
fi
