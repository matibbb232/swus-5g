# main.tf
terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

provider "virtualbox" {}

resource "virtualbox_vm" "master" {
  name = "k8s-master"
  os_type = "Ubuntu_64"
  cpus = 2
  memory = "2048 mib"
  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"
  }
  disk {
    size = "20000 mib"
  }
}

resource "virtualbox_vm" "worker" {
  count = 2
  name = "k8s-worker-${count.index + 1}"
  os_type = "Ubuntu_64"
  cpus = 2
  memory = "2048 mib"
  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"
  }
  disk {
    size = "20000 mib"
  }
}

resource "null_resource" "provision_master" {
  depends_on = [virtualbox_vm.master]

  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no ubuntu@${virtualbox_vm.master.network_adapter.0.ipv4_address} <<'EOF'
        sudo kubeadm init --pod-network-cidr=10.244.0.0/16
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        kubectl apply -f https://raw.githubusercontent.com/intel/multus-cni/master/deployments/multus-daemonset.yml
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
      EOF
    EOT
  }
}

resource "null_resource" "provision_worker" {
  count = 2
  depends_on = [virtualbox_vm.worker, null_resource.provision_master]

  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no ubuntu@${virtualbox_vm.worker[count.index].network_adapter.0.ipv4_address} <<'EOF'
        sudo kubeadm join ${virtualbox_vm.master.network_adapter.0.ipv4_address}:6443 --token TOKEN --discovery-token-ca-cert-hash sha256:HASH
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
      EOF
    EOT
  }
}

