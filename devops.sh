#!/usr/bin/bash

set -e
# set -x

devops () {
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo '\n \n \n'
kubectl version --client
echo '\n \n \n'

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip
echo '\n \n \n'
sudo ./aws/install --update
echo '\n \n \n'
aws --version

#sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && sudo yum -y install terraform
wget https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip
unzip $(echo terraform*.zip)
sudo install -o root -g root -m 0755 terraform  /usr/local/bin/terraform
terraform -install-autocomplete
echo '\n \n \n'
terraform  --version
echo '\n \n \n'

#curl https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64 -o terragrunt
wget -O terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64
sudo install -o root -g root -m 0755 terragrunt /usr/local/bin/terragrunt
echo '\n \n \n'
terragrunt --version

curl -o- https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
helm version

# https://github.com/tektoncd/cli + https://tekton.dev/docs/cli/
sudo  rpm -Uvh https://github.com/tektoncd/cli/releases/download/v0.23.1/tektoncd-cli-0.23.1_Linux-64bit.rpm
sudo ln -s /usr/bin/tkn /usr/local/bin/kubectl-tkn
mkdir -p ~/bin
kubectl plugin list
# curl -LO https://github.com/tektoncd/cli/releases/download/v0.23.1/tkn_0.23.1_Linux_x86_64.tar.gz
# sudo tar xvzf tkn_0.23.1_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn


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
