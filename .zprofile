# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

source "$(brew --prefix git-extras)/share/git-extras/git-extras-completion.zsh"
source "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"


# NVM
export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"


# Lock computer and activate ScreenSaver
function afk() {
  open -a /System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine
}


# Upgrade everything with Brew
function brewit() {
  brew update && brew outdated --greedy && brew upgrade --greedy && brew autoremove && brew cleanup && brew doctor
}


# Get most up-to-date state of the git branch
function gitup() {
  if [ "$1" ]; then
    git checkout "$1"
  fi

  git fetch --all --prune && git remote update --prune && git pull
}


# Go to a specific project in the Workspace
function work() {
  local dir="$HOME/Workspace/$1"

  if [ ! -d "$dir" ]; then
    echo "work: $1: not a valid workspace project"
    return 1
  fi

  cd "$dir"
}
