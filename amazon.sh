#!/usr/bin/bash

set -e

basic () {
echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/environment
echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment
sudo yum update --assumeyes;
sudo amazon-linux-extras install epel docker -y;
sudo usermod -a -G docker ec2-user
#sudo systemctl enable docker
#sudo service docker start
sudo yum install -y curl tree tmux nano unzip vim wget git net-tools bash-completion zsh zsh-completion bind-utils bridge-utils jq
}

dev () {
# https://github.com/nvm-sh/nvm/#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source ~/.bashrc
nvm install 14.7.0

#sudo yum install golang -y
curl -OL https://go.dev/dl/go1.18.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.18.5.linux-amd64.tar.gz
mkdir -p ~/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
echo 'export GOPATH=$HOME/go' >> ~/.profile
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.profile
source ~/.profile
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
sudo sh /tmp/get-docker.sh || true 
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo service docker start
sudo systemctl status docker
sudo chmod 666 /var/run/docker.sock
docker run hello-world


sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
}

git () {
git config --global user.name "Amit Karpe"
git config --global user.email "amitkarpe@gmail.com"
git config --global credential.username amitkarpe
}


main () {
  basic
  dev
  docker
  git
}

main
