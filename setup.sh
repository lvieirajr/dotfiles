#!/bin/bash

set -eux

WORKSPACE_DIR="Workspace"
DOTFILES_REPO="https://github.com/lvieirajr/dotfiles.git"

# Change to User's root directory
cd ~/

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Oh My ZSH
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k ZSH Theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Create Workspace directory
mkdir ${WORKSPACE_DIR}

# Clone dotfiles repository to '~/Workspace/dotfiles/'
git clone --depth=1 ${DOTFILES_REPO} ${WORKSPACE_DIR}/dotfiles

# Copy dotfiles into the User's root directory
rsync -av --exclude=README.md --exclude=setup.sh ${WORKSPACE_DIR}/dotfiles/* .

# Request the computer's name
read -p "User friendly computer name: " computer_name

# Request the computer's hostname
read -p "Computer's host name: " host_name

# Request the computer's Net BIOS name
read -p "Computer's Net BIOS name (15 char limit): " net_bios_name
