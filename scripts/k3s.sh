# https://k3s.io/
# https://github.com/k3s-io/k3s

#sudo systemctl enable docker
#sudo service docker start

#curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 777 --docker

# curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 777 --docker --no-deploy traefik

export INSTALL_K3S_CHANNEL='stable'
export INSTALL_K3S_VERSION="v1.23.10+k3s1"
curl -sfL https://get.k3s.io | sh -
sudo chmod +r /etc/rancher/k3s/k3s.yaml
mkdir -p ~/.kube
cp -v /etc/rancher/k3s/k3s.yaml ~/.kube/config
export KUBECONFIG=~/.kube/config


echo "\n\n"
cat /etc/rancher/k3s/k3s.yaml

echo "\n\n"
kubectl config view
kubectl get node
