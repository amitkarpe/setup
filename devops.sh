#!/usr/bin/bash

set -e
# set -x

devops () {
mkdir -p ~/install && cd ~/install && pwd

if [[ ! -f /usr/local/bin/kubectl ]] 
then
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
printf "\n \n \n"
kubectl version --short --client
printf "\n \n \n"
fi

if [[ ! -f /usr/local/bin/aws ]]
then
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip -u /tmp/awscliv2.zip
printf "\n \n \n"
sudo ./aws/install # --update
printf "\n \n \n"
aws --version
fi

if [[ ! -f  /usr/local/bin/terraform ]]
then
#sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && sudo yum -y install terraform
wget https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip
unzip -u $(echo terraform*.zip)
sudo install -o root -g root -m 0755 terraform  /usr/local/bin/terraform
terraform -install-autocomplete || true
printf "\n \n \n"
terraform  --version
printf "\n \n \n"
fi

if [[ ! -f  /usr/local/bin/terragrunt ]]
then
#curl https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64 -o terragrunt
wget -O terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64
sudo install -o root -g root -m 0755 terragrunt /usr/local/bin/terragrunt
printf "\n \n \n"
terragrunt --version
printf "\n \n \n"
fi

if [[ ! -f  /usr/local/bin/helm ]]
then
curl -o- https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
printf "\n \n \n"
helm version
printf "\n \n \n"
fi

if [[ ! -f  /usr/local/bin/tkn ]]
then
curl -LO https://github.com/tektoncd/cli/releases/download/v0.23.1/tkn_0.23.1_Linux_x86_64.tar.gz
sudo tar xvzf tkn_0.23.1_Linux_x86_64.tar.gz
sudo install -o root -g root -m 0755 tkn /usr/local/bin/tkn
printf "\n \n \n"
tkn version
printf "\n \n \n"
fi


# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
# sudo install -o root -g root -m 0755 /tmp/eksctl /usr/local/bin/eksctl
# eksctl version
# curl -o /tmp/aws-iam-authenticator https://s3.us-west-2.amazonaws.com/amazon-eks/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
# sudo install -o root -g root -m 0755 /tmp/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
# aws-iam-authenticator version

#brew install helm kubernetes-cli k9s octant kube-ps1 kubectx stern
#brew install tektoncd-cli argocd
#brew upgrade skaffold k3d helm 
#brew upgrade jq kompose dive kustomise jib 
#brew install terraform terragrunt
cd
rm -rf ~/install

}

git () {
git config --global user.name "Amit Karpe"
git config --global user.email "amitkarpe@gmail.com"
git config --global credential.username amitkarpe
}

main () {
  devops
  git
}

main
