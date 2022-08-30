#!/usr/bin/bash

set -e

basic () {
sudo apt-get update -y # && sudo apt-get upgrade -y

#sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils bridge-utils jq
# sudo apt  install -y tree tmux nano unzip vim wget git net-tools bind9-utils bridge-utils bash-completion zsh zsh-completion htop jq
sudo apt install -y tree tmux nano unzip vim wget git net-tools zsh htop jq ca-certificates curl gnupg lsb-release
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
curl -OL https://go.dev/dl/go1.18.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.18.5.linux-amd64.tar.gz
mkdir -p ~/go
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc
go version
}

docker () {
#sudo apt-get remove -y docker docker-engine docker.io containerd runc
#sudo mkdir -p /etc/apt/keyrings
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update -y
#sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh
sudo usermod -a -G docker ubuntu
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable docker
sudo service docker start
sudo systemctl status docker
docker run hello-world


sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
}


git () {
if [[ ! -f  ~/.gitconfig ]]
then
git config --global user.name "Amit Karpe"
git config --global user.email "amitkarpe@gmail.com"
git config --global credential.username amitkarpe
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
