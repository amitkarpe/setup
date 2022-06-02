#!/usr/bin/bash

set -e

basic () {
sudo yum update --assumeyes;
sudo amazon-linux-extras install epel -y;
sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils  bridge-utils 
}

dev () {
# https://github.com/nvm-sh/nvm/#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install 14.7.0
}

devops () {
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmpawscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && sudo yum -y install terraform
terraform -install-autocomplete

#brew install helm kubernetes-cli k9s octant kube-ps1 kubectx stern
#brew install tektoncd-cli argocd
#brew upgrade skaffold k3d helm 
#brew upgrade jq kompose dive kustomise jib 
#brew install terraform terragrunt

}

main () {
  basic
  dev
  devops
}

main
