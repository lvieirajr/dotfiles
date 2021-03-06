rsync --exclude ".git/" \
    --exclude ".idea/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude ".vim" \
		--exclude ".vimrc" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		--exclude "brew.sh" \
		--exclude "bin/" \
		--exclude "init/" \
		--exclude "setup.sh" \
		-avh --no-perms . ~;

brew update
brew upgrade

brew bundle

brew cleanup

source .macos

rm -rf ~/init/ ~/Brewfile*
rm -rf ./Brewfile.lock.json

BREW_PREFIX=$(brew --prefix)

if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

source ~/.bash_profile;

#sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
