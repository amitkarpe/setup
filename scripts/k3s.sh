#!/usr/bin/bash

set -e

# Install Rancher and K3S without Docker
install_k3s() {
  export INSTALL_K3S_CHANNEL='stable'
  export INSTALL_K3S_VERSION="v1.23.10+k3s1"
  # https://rancher.com/docs/k3s/latest/en/installation/install-options/server-config/#cluster-options  
  # Use containerd
  # No --tls-san used
  curl -sfL https://get.k3s.io | sh  -s - --write-kubeconfig-mode 777
  # k3s --version
  # sudo chmod +r /etc/rancher/k3s/k3s.yaml
  mkdir -p ~/.kube
  cp -v /etc/rancher/k3s/k3s.yaml ~/.kube/config
  chmod 600 ~/.kube/config
  export KUBECONFIG=~/.kube/config
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
  sleep 10
  # kubectl get pods --namespace cert-manager; kubectl get svc --namespace cert-manager 
  # kubectl get services -o wide traefik -n kube-system -o json | jq -r '.status.loadBalancer.ingress[].ip'
  kubectl get services -o wide traefik -n kube-system || true
  helm install rancher rancher-stable/rancher \
    --namespace cattle-system \
    --create-namespace \
    --set hostname=${host} \
    --set bootstrapPassword=password \
    # --set ingress.tls.source=rancher 
    # --wait
  # kubectl -n cattle-system get deploy rancher 
  kubectl get services -o wide traefik -n kube-system
  kubectl describe Issuer -n cattle-system
  kubectl describe Certificate -n cattle-system
  kubectl get Issuer,Certificate,csr -A
}

install_tools() {
  if [[ ! -f $(which kubectl) ]];
  then
    curl -s -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/
    printf "\n \n \n"
    kubectl version
    printf "\n \n \n"
  fi

  if [[ ! -f $(which helm) ]];
  then
    curl -s -o- https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    # curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
    printf "\n \n \n"
    helm version
    printf "\n \n \n"
  fi
}

install_packages() {
  if [[ ! -f $(which jq) ]];
  then
    sudo apt-get update -y # && sudo apt-get upgrade -y
    sudo apt-get install -y tree tmux nano unzip vim wget git net-tools zsh htop jq ca-certificates curl gnupg lsb-release bat
    mkdir -p ~/bin; ln -s /usr/bin/batcat ~/bin/bat || true
  fi
}

main () {
  sleep 2
  install_packages
  install_tools
  install_k3s
  install_rancher
}

main
