#!/usr/bin/bash

set -e
set -x

devops () {
mkdir -p ~/install 
cd ~/install 
pwd

export cmd=aws
export path=/usr/local/bin/${cmd}
if [[ -f ${path} ]] 
then
printf "\n${cmd} is installed\n"
else
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -s -o "/tmp/awscliv2.zip"
unzip -uq /tmp/awscliv2.zip
printf "\n \n \n"
sudo ./aws/install --update
printf "\n \n \n"
aws --version
fi

export cmd=kubectl
export path=/usr/local/bin/${cmd}
if [[ -f ${path} ]] 
then
printf "\n${cmd} is installed\n"
else
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 ${cmd} ${path}
printf "\n \n \n"
kubectl version --short --client
printf "\n \n \n"
fi

export cmd=terraform
export path=/usr/local/bin/${cmd}
#echo ${cmd} ${path}
if [[ -f ${path} ]] 
then
printf "\n${cmd} is installed\n"
else
# wget https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip
curl -L https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip -s -o /tmp/terraform.zip
unzip -u /tmp/terraform.zip
sudo install -o root -g root -m 0755 ${cmd} ${path}
terraform -install-autocomplete || true
printf "\n \n \n"
terraform  --version
printf "\n \n \n"
fi

export cmd=terragrunt
export path=/usr/local/bin/${cmd}
#echo ${cmd} ${path}
if [[ -f ${path} ]] 
then
printf "\n${cmd} is installed\n"
else
# wget -O terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64
curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64 -s -o terragrunt
sudo install -o root -g root -m 0755 terragrunt /usr/local/bin/terragrunt
printf "\n \n \n"
terragrunt --version
printf "\n \n \n"
fi

export cmd=helm
export path=/usr/local/bin/${cmd}
#echo ${cmd} ${path}
if [[ -f ${path} ]] 
then
printf "\n${cmd} is installed\n"
else
curl -o- https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
printf "\n \n \n"
helm version
printf "\n \n \n"
fi

export cmd=tkn
export path=/usr/local/bin/${cmd}
#echo ${cmd} ${path}
if [[ -f ${path} ]] 
then
printf "\n${cmd} is installed\n"
else
curl -LO https://github.com/tektoncd/cli/releases/download/v0.23.1/tkn_0.23.1_Linux_x86_64.tar.gz -s
sudo tar xzf tkn_0.23.1_Linux_x86_64.tar.gz
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


main () {
  devops
}

main
