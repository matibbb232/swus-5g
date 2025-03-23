# Project files for deployment of [Free5gc](https://github.com/free5gc/free5gc) and [UERANSIM](https://github.com/aligungr/UERANSIM)

Goal was deploying 5g network on Kubernetes cluster.

Part of the project for SWUS course during the 2024Z semester at 
the Faculty of Electronics and Information Technology (FEIT), 
Warsaw University of Technology (WUT).

# Requaired tools:
- Terraform
- VirtualBox
- kubectl
- kubeadm

# Creating and configuring VMs
https://www.youtube.com/watch?v=EHDDm_iR1Fs

https://medium.com/@mojabi.rafi/create-a-kubernetes-cluster-using-virtualbox-and-without-vagrant-90a14d791617

## Create NAT Network

## Create VMs
Create 1 master node and 2 worker nodes
Adapter 1: bridged
Adapter 2: NAT Network, K8s-NAT-Network

Note: If Ubuntu installer is not finding ip address on second adapter, try changing it's MAC address.
Enable SSH on each one of them.

Paste ubuntu_no_password to /etc/sudoers.d/ubuntu_no_password to disable sudo prompting for password.

# Running terraform
```
terraform init
terraform apply
```
