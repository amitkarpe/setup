#!/usr/bin/bash

set -e

nvm () {

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.zshrc
nvm install 14.7.0
node --version
npm --version
nvm --version
source ~/.zshrc
}

aws-azure-login () {
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
source ~/.profile
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
source ${HOME}/.profile

npm install -g aws-azure-login
echo "Configure using: aws-azure-login --configure --profile <Profile Name>"
echo "Start session using: aws-azure-login --no-prompt --mode=gui --profile <Profile Name>"

}

main () {
  nvm
  aws-azure-login
  
}

main

