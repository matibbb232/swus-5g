#!/bin/sh

# updating system
sudo apt-get update

# installing docker
sudo apt-get install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker

# adding K8s repos
sudo apt-get install apt-transport-https curl -y
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -k # -k of - ?

sudo apt-add-repository 'deb http://apt.kubernetes.io/ kubernetes-xenial main' --yes
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# TODO: ADD /etc/hosts
echo "<ip_of_k8s-master> k8s-master" | tee -a /etc/hosts # or kube-master?


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
