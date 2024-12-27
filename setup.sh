#!/bin/bash

# Shell options
set -eu
set -o pipefail
shopt -s dotglob

# Constants
HOMEBREW=/opt/homebrew
OH_MY_ZSH=$HOME/.oh-my-zsh
POWERLEVEL10K=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
WORKSPACE=$HOME/Workspace
PERSONAL_PROJECTS=$WORKSPACE/lvieirajr
DOTFILES=$PERSONAL_PROJECTS/dotfiles

# Setup start
echo -e "Setting up Luis Vieira's dotfiles."
cd $HOME

# HomeBrew
if [ ! -d $HOMEBREW ]; then
    echo -e "Installing HomeBrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo -e "Finished installing HomeBrew."
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Oh My ZSH
if [ ! -d $OH_MY_ZSH ]; then
    echo -e "Installing Oh my zsh..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo -e "Finished installing Oh my zsh."
fi

# Powerlevel10k
if [ ! -d $POWERLEVEL10K ]; then
    echo -e "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo -e "Finished installing Powerlevel10k."
fi

# Workspace
if [ ! -d $PERSONAL_PROJECTS ]; then
    echo -e "Creating personal projects directory..."
    mkdir -p $PERSONAL_PROJECTS
    echo -e "Finished creating personal projects directory."
fi

# Dotfiles
echo -e "Cloning dotfiles..."

if [ -d $DOTFILES ]; then
    rm -rf $DOTFILES
fi

git clone --depth=1 https://github.com/lvieirajr/dotfiles.git $DOTFILES
echo -e "Finished cloning dotfiles."

echo -e "Copying dotfiles to home directory..."
rsync -av --force --exclude='.git' --exclude='README.md' --exclude='setup.sh' $DOTFILES/* $HOME/
echo -e "Finished copying dotfiles to home directory."

# MacOS defaults
echo -e "Setting computer names..."

while true; do
    read -p "User friendly computer name (e.g. Luis Vieira's M4 MacBook Pro): " -r computer_name
    if [[ -n "$computer_name" ]]; then
      sudo scutil --set ComputerName "$computer_name"
      break
    else
      echo "Computer name can not be empty. Please try again."
    fi
done

while true; do
    read -p "Computer's host name (e.g. luis-vieiras-m4-macbook-pro): " -r host_name
    if [[ -n "$host_name" ]]; then
      sudo scutil --set HostName "$host_name"
      sudo scutil --set LocalHostName "$host_name"
      break
    else
      echo "Host name can not be empty. Please try again."
    fi
done

while true; do
    read -p "Computer's Net BIOS name (e.g. LVM4MBP): " -r net_bios_name
    if [[ -n "$net_bios_name" ]]; then
      sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$net_bios_name"
      break
    else
      echo "NetBIOS name can not be empty. Please try again."
    fi
done

echo -e "Finished setting computer names..."


# Brewfile
echo -e "Installing dependencies from Brewfile..."
brew bundle install
echo -e "Finished installing dependencies from Brewfile."


# Clean up
echo -e "Cleaning up..."
rm -rf $DOTFILES
echo -e "Finished cleaning up."
