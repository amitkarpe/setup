#!/usr/bin/bash

set -e

basic () {
sudo apt-get update -y # && sudo apt-get upgrade -y

#sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils bridge-utils jq
# sudo apt  install -y tree tmux nano unzip vim wget git net-tools bind9-utils bridge-utils bash-completion zsh zsh-completion htop jq
sudo apt install -y tree tmux nano unzip vim wget git net-tools zsh htop jq 
#sudo apt install -y apt-file tasksel
# bind9-utils bridge-utils bash-completion
}

dev () {
# https://github.com/nvm-sh/nvm/#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install 14.7.0

# sudo apt install golang -y
curl -O https://storage.googleapis.com/golang/go1.13.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz
sudo mv go /usr/local
mkdir -p ~/go
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc
go version
}

docker () {
#sudo usermod -a -G docker ubuntu
#sudo systemctl enable docker
#sudo service docker start
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
