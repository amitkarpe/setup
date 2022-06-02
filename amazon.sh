#!/usr/bin/bash

set -e

basic () {
sudo amazon-linux-extras install epel -y;
sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils  bridge-utils 
}

dev () {
# https://github.com/nvm-sh/nvm/#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install 14.7.0
}

devops () {
sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && sudo yum -y install terraform
terraform -install-autocomplete

}

main () {
  basic
  dev
  devops
}

main
