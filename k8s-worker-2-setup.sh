#!/bin/sh

# DISABLE IP FORWARD
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# INSTALL DOCEKER
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install docker.io -y

sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker

sudo systemctl enable docker
sudo systemctl start docker

# INSTALL KUBERNETES
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=1.30.2-1.1 kubeadm=1.30.2-1.1 kubectl=1.30.2-1.1
sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm version

sudo swapoff -a

sudo sed -i 's/KUBELET_EXTRA_ARGS=/KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"/g' /etc/default/kubelet
sudo systemctl enable --now kubelet

sudo kubeadm init --apiserver-advertise-address 192.168.60.11 --control-plane-endpoint 192.168.60.11
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# add replacing cgroup driver to systemd
