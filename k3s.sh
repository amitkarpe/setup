# https://k3s.io/
# https://github.com/k3s-io/k3s

sudo systemctl enable docker
sudo service docker start

export INSTALL_K3S_VERSION="v1.21.5+k3s2"
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 777 --docker

# curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 777 --docker --no-deploy traefik


mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
export KUBECONFIG=~/.kube/config
kubectl get pods --all-namespaces

echo $KUBECONFIG
kubectl get node
kubectl config view
