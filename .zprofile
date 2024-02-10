# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"


# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"


# Brew master command
function brewit() {
  brew update && brew outdated --greedy && brew upgrade --greedy && brew autoremove && brew cleanup && brew doctor
}


# Lock computer and activate ScreenSaver
function afk() {
  open -a /System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine
}


# Go to a specific project in the Workspace
function work() {
  cd ~/Workspace/$1/
}


# Get most up-to-date state of the git branch
function gitup() {
  if [ "$1" ]; then
    git checkout "$1"
  fi

  git fetch --all && git remote update && git remote prune origin && git pull
}
