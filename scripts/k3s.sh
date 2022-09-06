#!/usr/bin/bash

set -e

install_k3s() {
  # export INSTALL_K3S_CHANNEL='stable'
  # export INSTALL_K3S_VERSION="v1.23.10+k3s1"
  # curl -sfL https://get.k3s.io | sh  -s - --write-kubeconfig-mode 777
  # k3s --version
  export IP=$(curl -s ipconfig.io); echo $IP

  curl -sLS https://get.k3sup.dev | sh
  sudo install k3sup /usr/local/bin/
  k3sup install --local --k3s-version v1.24.4+k3s1 \
  --print-command \
  --print-config \
  --tls-san ${IP} \
  --local-path $HOME/.kube/config

  # sudo chmod +r /etc/rancher/k3s/k3s.yaml
  # mkdir -p ~/.kube
  # cp -v /etc/rancher/k3s/k3s.yaml ~/.kube/config
  # chmod 600 ~/.kube/config
  # export KUBECONFIG=~/.kube/config
  # echo "\n\n"
  # cat /etc/rancher/k3s/k3s.yaml
  # echo "\n\n"
  # kubectl config view
  # kubectl get node
}

install_rancher() {
  export IP=$(curl -s ipconfig.io); echo $IP
  export host=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname); echo $host
  helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
  helm repo add jetstack https://charts.jetstack.io

  helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --set installCRDs=true \
    --version v1.7.1 \
    --wait

  kubectl get pods --namespace cert-manager; kubectl get svc --namespace cert-manager 
  kubectl get services -o wide traefik -n kube-system -o json | jq -r '.status.loadBalancer.ingress[].ip'

  helm install rancher rancher-stable/rancher \
    --namespace cattle-system \
    --create-namespace \
    --set hostname=${host} \
    --set bootstrapPassword=longpasswordIjw92319oDOXXXXX \
    --wait
  kubectl -n cattle-system get deploy rancher 
  kubectl get services -o wide traefik -n kube-system

}

install_tools() {
  export cmd=kubectl
  export cmdpath=/usr/local/bin/${cmd}
  if [[ -f ${cmdpath} ]] 
  then
  printf "\n${cmd} is installed\n"
  else
  curl -s -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 ${cmd} ${cmdpath}
  printf "\n \n \n"
  kubectl version --short --client
  printf "\n \n \n"
  fi

  export cmd=helm
  export cmdpath=/usr/local/bin/${cmd}
  if [[ -f ${cmdpath} ]] 
  then
  printf "\n${cmd} is installed\n"
  else
  curl -s -o- https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  # curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
  printf "\n \n \n"
  helm version
  printf "\n \n \n"
  fi
}


install_docker() {

if [[ ! -f $(which docker) ]];
then
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  sudo usermod -a -G docker ubuntu
  sudo chmod 666 /var/run/docker.sock
  sudo systemctl enable docker --now
  sudo systemctl status docker --no-pager
fi
docker version || true
}

install_packages() {
  sudo apt-get update -y # && sudo apt-get upgrade -y
  sudo apt-get install -y tree tmux nano unzip vim wget git net-tools zsh htop jq ca-certificates curl gnupg lsb-release bat
  mkdir -p ~/bin; ln -s /usr/bin/batcat ~/bin/bat || true
}

main () {
  sleep 2
  install_packages
  install_tools
  install_docker
  install_k3s
  install_rancher
}

main
