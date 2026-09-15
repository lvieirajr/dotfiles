#!/bin/bash


# Shell options
set -euo pipefail
shopt -s dotglob


# Constants
HOMEBREW="/opt/homebrew"
OH_MY_ZSH="$HOME/.oh-my-zsh"
POWERLEVEL10K="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
WORKSPACE="$HOME/Workspace"
PERSONAL_PROJECTS="$WORKSPACE/lvieirajr"
DOTFILES="$PERSONAL_PROJECTS/dotfiles"


# Setup start
echo "Setting up Luis Vieira's dotfiles..."
cd "$HOME"


# Computer Identity
echo "Setting computer names..."

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


# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install

  echo "Waiting for Xcode Command Line Tools installation to complete..."

  for _ in {1..360}; do
    if xcode-select -p &>/dev/null; then
      break
    fi
    sleep 5
  done

  if ! xcode-select -p &>/dev/null; then
    echo "Xcode Command Line Tools installation did not complete." >&2
    exit 1
  fi
fi


# Install Rosetta 2
if [[ "$(uname -m)" == "arm64" ]]; then
  if ! /usr/bin/arch -x86_64 /usr/bin/true &>/dev/null; then
    echo "Installing Rosetta 2..."
    sudo softwareupdate --agree-to-license --install-rosetta
  fi
fi


# Oh My ZSH
if [ ! -d "$OH_MY_ZSH" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# Powerlevel10k
if [ ! -d "$POWERLEVEL10K" ]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K"
fi


# Workspace
mkdir -p "$PERSONAL_PROJECTS"


# Dotfiles
if [ -d "$DOTFILES/.git" ]; then
  echo "Using existing dotfiles clone."
elif [ -e "$DOTFILES" ]; then
  echo "Error: $DOTFILES exists but is not a Git repository." >&2
  exit 1
else
  echo "Cloning dotfiles..."
  git clone https://github.com/lvieirajr/dotfiles.git "$DOTFILES"
fi


echo "Copying dotfiles to home directory..."
rsync -av --force --exclude=".git" --exclude="README.md" --exclude="setup.sh" "$DOTFILES/" "$HOME/"


# Homebrew
if [ ! -x "$HOMEBREW/bin/brew" ]; then
  echo "Setting up Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x "$HOMEBREW/bin/brew" ]; then
  echo "Homebrew installation failed." >&2
  exit 1
fi

eval "$("$HOMEBREW/bin/brew" shellenv)"

"$HOMEBREW/bin/brew" bundle install --file="$HOME/Brewfile"

if [ -d "$HOMEBREW/share" ]; then
  chmod go-w "$HOMEBREW/share"
fi

if [ -d "$HOMEBREW/share/zsh" ]; then
  chmod -R go-w "$HOMEBREW/share/zsh"
fi

# Mise
echo "Setting up Mise-en-place..."
curl https://mise.run | sh
mise install

# Zsh completions
echo "Configuring zsh completions..."

rm -f "$HOME/.zcompdump"

zsh -c '
  autoload -Uz compaudit compinit

  insecure=("${(@f)$(compaudit)}")
  if (( ${#insecure} )); then
    chmod g-w,o-w "${insecure[@]}"
  fi

  compinit
'

echo "Setup complete."
