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
kubectl version

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip
sudo ./aws/install
aws --version

sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && sudo yum -y install terraform
terraform -install-autocomplete
terraform  --version

#curl https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64 -o terragrunt
wget -O terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64
sudo install -o root -g root -m 0755 terragrunt /usr/local/bin/terragrunt
terragrunt --version

#brew install helm kubernetes-cli k9s octant kube-ps1 kubectx stern
#brew install tektoncd-cli argocd
#brew upgrade skaffold k3d helm 
#brew upgrade jq kompose dive kustomise jib 
#brew install terraform terragrunt

}

git () {
git config --global user.name "Amit Karpe"
git config --global user.email "amitkarpe@gmail.com"
git config --global credential.username amitkarpe
}


main () {
  basic
  dev
  devops
  git
}

main
