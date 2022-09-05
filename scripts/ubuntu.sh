#!/usr/bin/bash

set -e

basic () {
sudo apt-get update -y # && sudo apt-get upgrade -y
# sudo apt  install -y tree tmux nano unzip vim wget git net-tools bind9-utils bridge-utils bash-completion zsh zsh-completion htop jq
sudo apt-get install -y tree tmux nano unzip vim wget git net-tools zsh htop jq ca-certificates curl gnupg lsb-release
#sudo apt install -y apt-file tasksel

}

dev () {
if [[ ! -f $(which nvm) ]]
then
# https://github.com/nvm-sh/nvm/#installing-and-updating
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
if [[ ! -f $(which node) ]]
then
  nvm install 14.7.0
fi
nvm version
node -v
npm version


if [[ ! -f $(which go) ]]
then
  curl -OL https://go.dev/dl/go1.18.5.linux-amd64.tar.gz -s
  sudo tar -C /usr/local -xf go1.18.5.linux-amd64.tar.gz
  mkdir -p ~/go
  export GOPATH=$HOME/go
  export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
  echo 'export GOPATH=$HOME/go' >> ~/.bashrc
  echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
  source ~/.bashrc
fi
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
set -x
curl -o ~/.gitconfig https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.gitconfig
curl -o ~/.gitignore_global https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.gitignore_global

export PAGER=''
sleep 2
git config --global --list
cat ~/.gitconfig
set +x
fi
}


main () {
  sleep 2
  basic
  dev
  docker
  git
}

main
