#!/usr/bin/bash

set -e

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install 14.7.0
node --version

source ~/.zshrc

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
source ~/.profile
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
source ${HOME}/.profile

npm install -g aws-azure-login
