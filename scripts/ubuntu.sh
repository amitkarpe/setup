#!/usr/bin/bash

# Set non-interactive mode for apt commands
export DEBIAN_FRONTEND=noninteractive

set -e

install_packages() {
if [[ ! -f $(which zsh) ]]
then
  sudo apt-get update -y # && sudo apt-get upgrade -y
  sudo apt-get install -y tree tmux nano unzip vim wget git net-tools zsh htop jq ca-certificates curl gnupg lsb-release
fi

# if [[ ! -f $(which yum) ]]
# then
#   sudo yum update --assumeyes;
#   sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils bridge-utils jq
#   # sudo amazon-linux-extras install epel docker -y; sudo usermod -a -G docker ec2-user
# fi

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

# Add Java (required for Nextflow)
if [[ ! -f $(which java) ]] || ! java -version 2>&1 | grep -q 'openjdk version "11' ;
then
  echo "Installing OpenJDK 11..."
  sudo apt-get update -y
  sudo apt-get install -y openjdk-11-jdk
else
 echo "Java 11 already installed."
fi
java -version

# Add Python3 and pip (required for nf-core)
if [[ ! -f $(which python3) ]] || [[ ! -f $(which pip3) ]] ;
then
  echo "Installing Python3 and pip3..."
  sudo apt-get update -y
  sudo apt-get install -y python3 python3-pip python3-venv
else
 echo "Python3 and pip3 already installed."
fi
python3 --version
pip3 --version
}

install_docker() {

if [[ ! -f $(which docker) ]]
then
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  sudo usermod -a -G docker ubuntu
  sudo chmod 666 /var/run/docker.sock
  # sudo systemctl enable docker --now
  # sudo systemctl status docker --no-pager
  # docker run hello-world
fi
docker version

if [[ ! -f $(which docker-compos) ]]
then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -s -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi
docker-compose --version

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
