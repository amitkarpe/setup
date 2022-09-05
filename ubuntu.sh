#!/usr/bin/bash

set -e

basic () {
sudo apt-get update -y # && sudo apt-get upgrade -y

#sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils bridge-utils jq
# sudo apt  install -y tree tmux nano unzip vim wget git net-tools bind9-utils bridge-utils bash-completion zsh zsh-completion htop jq
sudo apt-get install -y tree tmux nano unzip vim wget git net-tools zsh htop jq ca-certificates curl gnupg lsb-release
#sudo apt install -y apt-file tasksel
# bind9-utils bridge-utils bash-completion
}

dev () {
# https://github.com/nvm-sh/nvm/#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source ~/.bashrc
nvm install 14.7.0

# sudo apt install golang -y
#curl -O https://storage.googleapis.com/golang/go1.13.5.linux-amd64.tar.gz
#sudo rm -rf /usr/local/go
#curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
curl -OL https://go.dev/dl/go1.18.5.linux-amd64.tar.gz -s
sudo tar -C /usr/local -xf go1.18.5.linux-amd64.tar.gz
mkdir -p ~/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc
go version
}

docker () {

if [[ ! -f $(which docker) ]]
then
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  sudo usermod -a -G docker ubuntu
  sudo chmod 666 /var/run/docker.sock
  sudo systemctl enable docker --now
  sudo systemctl status docker --no-pager
  docker run hello-world
fi
docker version

if [[ ! -f $(which docker-compos) ]]
then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -s -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi
docker-compose --version

}


git () {
if [[ ! -f  ~/.gitconfig ]]
then
git config --global user.name "Amit Karpe"
git config --global user.email "amitkarpe@gmail.com"
git config --global credential.username amitkarpe
git config --global credential.host github.com
git config --global core.editor "vim"
git config --global color.ui true
git config --global color.ui auto
git config --global color.status auto
git config --global color.branch auto
git config --global color.diff auto
git config --global core.excludesfile ~/.gitignore_global
curl -o ~/.gitignore_global https://raw.githubusercontent.com/amitkarpe/setup/main/.gitignore_global

export PAGER=''
git config --global --list
cat ~/.gitconfig
fi
}


main () {
  basic
  dev
  docker
  git
}

main
