#!/bin/bash

# Shell options
set -eu
shopt -s dotglob

# Constants
HOMEBREW="/opt/homebrew"
OH_MY_ZSH="$HOME/.oh-my-zsh"
POWERLEVEL10K="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
WORKSPACE="$HOME/Workspace"
PERSONAL_PROJECTS="$HOME/Workspace/lvieirajr"
DOTFILES="$PERSONAL_PROJECTS/dotfiles"

# Setup start
echo -e "Setting up Luis Vieira's dotfiles.\n"
cd "$HOME"

# HomeBrew
if [ ! -d "$HOMEBREW" ]; then
    echo -e "\nInstalling HomeBrew...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo -e "\nFinished installing HomeBrew.\n"
fi

# Oh My ZSH
if [ ! -d "$OH_MY_ZSH" ]; then
    echo -e "\nInstalling Oh my zsh...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo -e "\nFinished installing Oh my zsh.\n"
fi

# Powerlevel10k
if [ ! -d "$POWERLEVEL10K" ]; then
    echo -e "\nInstalling Powerlevel10k...\n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
    echo -e "\nFinished installing Powerlevel10k.\n"
fi

# Workspace
if [ ! -d "$WORKSPACE" ]; then
    echo -e "\nCreating Workspace directory...\n"
    mkdir "$WORKSPACE"
    mkdir "$PERSONAL_PROJECTS"
    echo -e "\nFinished creating Workspace directory.\n"
fi

# Dotfiles
echo -e "\nCloning dotfiles...\n"

if [ ! -d "$DOTFILES" ]; then
    rm -rf "$DOTFILES"
fi

git clone --depth=1 https://github.com/lvieirajr/dotfiles.git "$DOTFILES"
echo -e "\nFinished cloning dotfiles.\n"

echo -e "\nCopying dotfiles to home directory...\n"
rsync -av --force --exclude=.git --exclude=README.md --exclude=setup.sh "$DOTFILES/*" "$HOME"
echo -e "\nFinished copying dotfiles to home directory.\n"

# MacOS defaults
read -p -r "User friendly computer name (e.g. Luis Vieira's 2023 MacBook Pro): " computer_name
read -p -r "Computer's host name (e.g. luis-vieiras-2023-macbook-pro): " host_name
read -p -r "Computer's Net BIOS name (e.g. LV2023MBP): " net_bios_name

# Brewfile
echo -e "\nRunning Brewfile...\n"
brew bundle install
echo -e "\nFinished running Brewfile.\n"

# Clean up
echo -e "\nCleaning up...\n"
rm -rf "$DOTFILES"
echo -e "\nFinished cleaning up.\n"
