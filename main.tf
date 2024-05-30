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
  name     = "k8s-master"
  image    = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.vmdk"
  cpus     = 2
  memory   = 2048
  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"
  }
}

resource "virtualbox_vm" "worker" {
  count    = 2
  name     = "k8s-worker-${count.index + 1}"
  image    = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.vmdk"
  cpus     = 2
  memory   = 2048
  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"
  }
}

resource "null_resource" "provision_master" {
  depends_on = [virtualbox_vm.master]

  provisioner "remote-exec" {
    inline = [
      "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",
      "mkdir -p $HOME/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "kubectl apply -f https://raw.githubusercontent.com/intel/multus-cni/master/deployments/multus-daemonset.yml",
      "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
      host     = virtualbox_vm.master.network_adapter[0].ipv4_address
    }
  }
}

resource "null_resource" "provision_worker" {
  count = 2
  depends_on = [virtualbox_vm.worker, null_resource.provision_master]

  provisioner "remote-exec" {
    inline = [
      "sudo kubeadm join ${virtualbox_vm.master.network_adapter[0].ipv4_address}:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>",
      "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
      host     = virtualbox_vm.worker[count.index].network_adapter[0].ipv4_address
    }
  }
}