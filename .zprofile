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
  # Zsh arrays
  local -a matches match_paths
  local target="$1"  # The folder name or path to search for
  local flag="$2"    # Optional flag: -o (organization), -p (project), or -f (full)
  local base_dir="$HOME/Workspace"

  setopt localoptions null_glob  # Don't choke on empty globs

  # If no argument is given, just cd into Workspace
  if [ -z "$target" ]; then
    cd "$base_dir" || return
    return 0
  fi

  ####################################################
  # Search "project" folders (any organization/project)
  # Return codes:
  #   0 -> exactly one match
  #   1 -> multiple matches
  #   2 -> no matches
  ####################################################
  function search_project() {
    matches=()
    match_paths=()

    for org_dir in "$base_dir"/*; do
      for proj_dir in "$org_dir"/*; do
        if [ -d "$proj_dir" ] && [[ "$(basename "$proj_dir")" == "$target" ]]; then
          matches+=("$(basename "$org_dir")")
          match_paths+=("$proj_dir")
        fi
      done
    done

    if [ "${#matches[@]}" -gt 1 ]; then
      echo "work: Multiple projects named '$target' found under different organizations:"
      for m in "${matches[@]}"; do
        echo "  - $m"
      done
      return 1  # multiple matches
    fi

    if [ "${#matches[@]}" -eq 1 ]; then
      cd "${match_paths[1]}" || return
      return 0  # found one match
    fi

    return 2    # no matches
  }

  ####################################################
  # Search "full" path:
  #   0 -> exactly one match
  #   1 -> multiple (if you want that scenario)
  #   2 -> no matches
  ####################################################
  function search_full() {
    local full_path="$base_dir/$target"

    # Direct folder under ~/Workspace
    if [ -d "$full_path" ]; then
      cd "$full_path" || return
      return 0
    fi

    # Otherwise check if it's an organization/project combo
    for org_dir in "$base_dir"/*; do
      for proj_dir in "$org_dir"/*; do
        if [ -d "$proj_dir" ] && [[ "$org_dir/$(basename "$proj_dir")" == "$full_path" ]]; then
          cd "$proj_dir" || return
          return 0
        fi
      done
    done
    return 2
  }

  ####################################################
  # Search "organization" folders (top level only)
  #   0 -> found
  #   2 -> not found
  ####################################################
  function search_org() {
    for org_dir in "$base_dir"/*; do
      if [ -d "$org_dir" ] && [[ "$(basename "$org_dir")" == "$target" ]]; then
        cd "$org_dir" || return
        return 0
      fi
    done
    return 2
  }

  # Helper to stop searching if we get return=1 or 0
  # usage: run_search search_function_name
  #  - If 0, we return immediately (success).
  #  - If 1, we return immediately (multiple matches).
  #  - If 2, keep going.
  function run_search() {
    "$1"
    local code=$?
    if [ $code -eq 0 ] || [ $code -eq 1 ]; then
      return $code
    fi
    # otherwise, code == 2 (not found), keep going
    return 2
  }

  # If the user specified a flag, use that specific search only
  case "$flag" in
    -p)  # Project
      run_search search_project
      case $? in
        0) return 0 ;;
        1) return 1 ;;
      esac
      echo "work: '$target' not found as a project"
      return 1
      ;;
    -f)  # Full path
      run_search search_full
      case $? in
        0) return 0 ;;
        1) return 1 ;;
      esac
      echo "work: '$target' not found as a full path in $base_dir"
      return 1
      ;;
    -o)  # Organization
      run_search search_org
      case $? in
        0) return 0 ;;
        1) return 1 ;;  # not used for organization
      esac
      echo "work: '$target' not found as an organization"
      return 1
      ;;
  esac

  # Otherwise, do the default order: project -> full -> organization
  run_search search_project
  case $? in
    0) return 0 ;;
    1) return 1 ;;
  esac

  run_search search_full
  case $? in
    0) return 0 ;;
    1) return 1 ;;
  esac

  run_search search_org
  case $? in
    0) return 0 ;;
    1) return 1 ;;
  esac

  # If all returned 2 (no matches)
  echo "work: '$target' not found"
  return 1
}
