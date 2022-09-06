#!/usr/bin/bash

set -e

install_packages() {
if [[ -f /usr/bin/apt-get ]]
then
  sudo apt-get update -y # && sudo apt-get upgrade -y
  sudo apt-get install -y tree tmux nano unzip vim wget git net-tools zsh htop jq ca-certificates curl gnupg lsb-release bat
  mkdir -p ~/bin; ln -s /usr/bin/batcat ~/bin/bat
fi

if [[ -f /usr/bin/yum ]]
then
  sudo yum update --assumeyes;
  sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils bridge-utils jq
  sudo amazon-linux-extras install epel docker -y; sudo usermod -a -G docker ec2-user
  # sudo systemctl enable docker --now; sudo systemctl status docker --no-pager  
fi
}

install_dev() {
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
  sudo rm -rf go 1.18.5.linux-amd64.tar.gz
  source ~/.bashrc
fi
go version
}

install_docker() {

# if [[ -f "/usr/bin/yum"  &&  ! -f "/usr/bin/docker" ]];
# then
#   sudo amazon-linux-extras install docker -y
#   sudo usermod -a -G docker ec2-user
#   sudo systemctl enable docker --now
#   sudo systemctl status docker --no-pager
# fi

if [[ ! -f $(which docker) ]];
then
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  sudo usermod -a -G docker ubuntu
  # sudo chmod 666 /var/run/docker.sock
  # sudo systemctl enable docker --now
  # sudo systemctl status docker --no-pager
fi
docker version || true

if [[ ! -f $(which docker-compos) ]]
then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -s -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi
docker-compose --version || true
}


install_git() {
if [[ ! -f  ~/.gitconfig ]]
then
set -x
curl -o ~/.gitconfig https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.gitconfig
curl -o ~/.gitignore_global https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.gitignore_global

export PAGER=''
# git config --global --list
cat ~/.gitconfig
set +x
fi
}


main () {
  sleep 2
  install_packages
  install_dev
  install_docker
  install_git
}

main
