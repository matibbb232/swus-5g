# main.tf
terraform {
  required_providers {
  }
}

variable "k8s-master-ip" {
  type    = string
  default = "192.168.1.20"
}
variable "k8s-worker-1-ip" {
  type    = string
  default = "192.168.1.20"
}
variable "k8s-worker-2-ip" {
  type    = string
  default = "192.168.1.20"
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
      "chmod +x /home/ubuntu/k8s-setup.sh",
      "sudo /home/ubuntu/k8s-setup.sh"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      password = "ubuntu"
      host     = "192.168.1.20"
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
      host     = "192.168.1.20"
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
      host     = "192.168.1.20"
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
      host     = "192.168.1.20"
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
      host     = "192.168.1.20"
    }
  }
}
