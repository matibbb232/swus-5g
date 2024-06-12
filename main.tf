# main.tf
terraform {
  required_providers {
  }
}

variable "k8s-master-ip" {
  type    = string
  default = "192.168.1.16"
}
variable "k8s-worker-1-ip" {
  type    = string
  default = "192.168.1.17"
}
variable "k8s-worker-2-ip" {
  type    = string
  default = "192.168.1.18"
}

# k8s-master
resource "null_resource" "provision_master" {

  provisioner "file" {
    source      = "k8s-master-setup.sh"
    destination = "/home/ubuntu/k8s-master-setup.sh"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      password = "ubuntu"
      host     = var.k8s-master-ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/k8s-master-setup.sh",
      "sudo /home/ubuntu/k8s-master-setup.sh"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      password = "ubuntu"
      host     = var.k8s-master-ip
    }
  }
}


# k8s-worker-1
resource "null_resource" "provision_worker_1" {
  provisioner "file" {
    source      = "k8s-worker-1-setup.sh"
    destination = "/home/ubuntu/k8s-worker-1-setup.sh"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      password = "ubuntu"
      host     = var.k8s-worker-1-ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/k8s-worker-1-setup.sh",
      "sudo /home/ubuntu/k8s-worker-1-setup.sh"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      password = "ubuntu"
      host     = var.k8s-worker-1-ip
    }
  }
}

# k8s-worker-2
resource "null_resource" "provision_worker_2" {
  provisioner "file" {
    source      = "k8s-worker-2-setup.sh"
    destination = "/home/ubuntu/k8s-worker-2-setup.sh"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      password = "ubuntu"
      host     = var.k8s-worker-2-ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/k8s-worker-2-setup.sh",
      "sudo /home/ubuntu/k8s-worker-2-setup.sh"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      password = "ubuntu"
      host     = var.k8s-worker-2-ip
    }
  }
}
