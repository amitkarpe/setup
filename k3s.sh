curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 777 --docker --no-deploy traefik

# curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 777 --docker 


mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
export KUBECONFIG=~/.kube/config
kubectl get pods --all-namespaces

echo $KUBECONFIG
kubectl get node
kubectl config view
