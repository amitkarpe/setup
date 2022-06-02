#!/usr/bin/bash

set -e

basic () {
echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/environment
echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment
sudo yum update --assumeyes;
sudo amazon-linux-extras install epel -y;
sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils bridge-utils jq
}

dev () {
# https://github.com/nvm-sh/nvm/#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install 14.7.0

sudo yum install golang -y

}



git () {
git config --global user.name "Amit Karpe"
git config --global user.email "amitkarpe@gmail.com"
git config --global credential.username amitkarpe
}


main () {
  basic
  dev
  git
}

main
