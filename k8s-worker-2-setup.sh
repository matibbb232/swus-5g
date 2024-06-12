#!/bin/sh

# updating system
sudo apt-get update

# installing docker
sudo apt-get install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker

# adding K8s repos
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet

# TODO: ADD /etc/hosts
#    <IPofK8sMaster>
sudo echo "192.168.10.4 k8s-master" | sudo tee -a /etc/hosts # or kube-master?

sudo swapoff -a
sudo kubeadm init --control-plane-endpoint kube-master:6443 --pod-network-cidr 10.10.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# installing Multus plugin
git clone https://github.com/k8snetworkplumbingwg/multus-cni.git && cd multus-cni && kubectl apply -f ./deployments/multus-daemonset-thick-plugin.yml

# installing helm (TODO: might not be enough)
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm -y
