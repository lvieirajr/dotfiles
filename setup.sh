#!/bin/bash

set -eu


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

if [ ! -d $DOTFILES ]; then
    echo -e "\nCloning dotfiles...\n"
    git clone --depth=1 https://github.com/lvieirajr/dotfiles.git $DOTFILES
    echo -e "\nFinished cloning dotfiles.\n"
fi

echo -e "\nCopying dotfiles to home directory...\n"
rsync -av --force $DOTFILES/* $HOME
echo -e "\nFinished copying dotfiles to home directory.\n"

read -p "User friendly computer name: " computer_name
read -p "Computer's host name: " host_name
read -p "Computer's Net BIOS name (15 char limit): " net_bios_name

echo -e "\nCleaning up...\n"
rm -rf $DOTFILES
echo -e "\nFinished cleaning up.\n"
