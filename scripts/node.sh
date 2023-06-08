#!/usr/bin/zsh

set -e

install_nvm() {

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

install_node() {
nvm install --lts
node --version
npm --version
nvm --version
npm install -g yarn
}

main () {
	install_nvm
	install_node
	source ~/.zshrc
}

main
