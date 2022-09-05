#!/usr/bin/bash

set -x

azure_login () { 
#source ~/.zshrc
mkdir -p ~/.npm-global
#npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
touch ~/.profile
source ${HOME}/.profile
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
source ${HOME}/.profile

npm install -g aws-azure-login
echo "For more information about aws-azure-login, check https://github.com/DTN-Public/aws-azure-login"
echo "Configure using: aws-azure-login --configure --profile <Profile Name>"
echo "Start session using: aws-azure-login --no-prompt --mode=gui --profile <Profile Name>"

}

main () {
	azure_login
}

main
