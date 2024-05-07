#!/bin/bash

set -eu
shopt -s dotglob


HOMEBREW="/opt/homebrew"
OH_MY_ZSH="$HOME/.oh-my-zsh"
POWERLEVEL10K="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
WORKSPACE="$HOME/Workspace"
DOTFILES="$WORKSPACE/dotfiles"


echo -e "Setting up Luis Vieira's dotfiles.\n"
cd $HOME


if [ ! -d $HOMEBREW ]; then
    echo -e "\nInstalling HomeBrew...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo -e "\nFinished installing HomeBrew.\n"
fi

if [ ! -d $OH_MY_ZSH ]; then
    echo -e "\nInstalling Oh my zsh...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo -e "\nFinished installing Oh my zsh.\n"
fi

if [ ! -d $POWERLEVEL10K ]; then
    echo -e "\nInstalling Powerlevel10k...\n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo -e "\nFinished installing Powerlevel10k.\n"
fi

if [ ! -d $WORKSPACE ]; then
    echo -e "\nCreating Workspace directory...\n"
    mkdir $WORKSPACE
    echo -e "\nFinished creating Workspace directory.\n"
fi

echo -e "\nCloning dotfiles...\n"
git clone -f --depth=1 https://github.com/lvieirajr/dotfiles.git $DOTFILES
echo -e "\nFinished cloning dotfiles.\n"

echo -e "\nCopying dotfiles to home directory...\n"
rsync -av --force --exclude=.git --exclude=README.md --exclude=setup.sh $DOTFILES/* $HOME
echo -e "\nFinished copying dotfiles to home directory.\n"

read -p "User friendly computer name: " computer_name
read -p "Computer's host name: " host_name
read -p "Computer's Net BIOS name (15 char limit): " net_bios_name

echo -e "\nRunning Brewfile...\n"
brew bundle install
echo -e "\nFinished running Brewfile.\n"

echo -e "\nCleaning up...\n"
rm -rf $DOTFILES
echo -e "\nFinished cleaning up.\n"
