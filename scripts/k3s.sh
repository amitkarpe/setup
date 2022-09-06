
#!/usr/bin/bash

set -e

install_k3s() {
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
  export INSTALL_K3S_CHANNEL='stable'
  export INSTALL_K3S_VERSION="v1.23.10+k3s1"
  if [[ ! -f $(which k3s) ]]
  then
    curl -sfL https://get.k3s.io | sh  -s - --write-kubeconfig-mode 777 --docker
  fi
  k3s --version
  sudo usermod -a -G docker ubuntu
  sudo systemctl enable docker --now; sudo systemctl status docker --no-pager; docker run hello-world
  sudo chmod +r /etc/rancher/k3s/k3s.yaml
  mkdir -p ~/.kube
  cp -v /etc/rancher/k3s/k3s.yaml ~/.kube/config
  export KUBECONFIG=~/.kube/config
  echo "\n\n"
  cat /etc/rancher/k3s/k3s.yaml
  echo "\n\n"
  kubectl config view
  kubectl get node
}

install_packages() {
if [[ -f /usr/bin/apt-get ]]
then
  sudo apt-get update -y # && sudo apt-get upgrade -y
  sudo apt-get install -y tree tmux nano unzip vim wget git net-tools zsh htop jq ca-certificates curl gnupg lsb-release bat
  mkdir -p ~/bin; ln -s /usr/bin/batcat ~/bin/bat || true
fi

install_docker() {

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
}

main () {
  sleep 2
  install_packages
  # install_docker
  install_k3s
}

main
