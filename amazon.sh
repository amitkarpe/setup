#!/usr/bin/bash

set -e

tools {
sudo amazon-linux-extras install epel -y; 
}

dev {
# https://github.com/nvm-sh/nvm/#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install 14.7.0
}

devops {
sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && sudo yum -y install terraform
terraform -install-autocomplete

}

main () {

}

main
