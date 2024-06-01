# main.tf
terraform {
  required_providers {
  }
}

# k8s-master
resource "null_resource" "provision_master" {

  provisioner "remote-exec" {
    inline = [
      "echo ubuntu | sudo su",
      # "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",
      # "mkdir -p $HOME/.kube",
      # "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      # "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      # "kubectl apply -f https://raw.githubusercontent.com/intel/multus-cni/master/deployments/multus-daemonset.yml",
      # "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
      "sudo touch hello_world_2"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      password = "ubuntu"
      host = "192.168.1.20"
    }
  }
}


# # k8s-worker-1
# resource "null_resource" "provision_worker_1" {

#   provisioner "remote-exec" {
#     inline = [
#       # "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",
#       # "mkdir -p $HOME/.kube",
#       # "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
#       # "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
#       # "kubectl apply -f https://raw.githubusercontent.com/intel/multus-cni/master/deployments/multus-daemonset.yml",
#       # "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
#       "touch hello_world"
#     ]

#     connection {
#       type     = "ssh"
#       user     = "ubuntu"
#       password = "ubuntu"
#       host = "192.168.1.20"
#     }
#   }
# }

# # k8s-worker-2
# resource "null_resource" "provision_worker_2" {

#   provisioner "remote-exec" {
#     inline = [
#       # "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",
#       # "mkdir -p $HOME/.kube",
#       # "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
#       # "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
#       # "kubectl apply -f https://raw.githubusercontent.com/intel/multus-cni/master/deployments/multus-daemonset.yml",
#       # "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
#       "touch hello_world"
#     ]

#     connection {
#       type     = "ssh"
#       user     = "ubuntu"
#       password = "ubuntu"
#       host = "192.168.1.20"
#     }
#   }
# }
