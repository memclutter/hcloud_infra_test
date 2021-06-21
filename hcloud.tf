terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.27.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {}
variable "hcloud_ssh_pub_key" {
  default = "~/.ssh/id_rsa.pub"
}
variable "hcloud_ssh_prv_key" {
  default = "~/.ssh/id_rsa"
}

provider "hcloud" {
  token = var.hcloud_token
}


resource "hcloud_ssh_key" "default" {
  name       = "Default SSH key"
  public_key = file(var.hcloud_ssh_pub_key)
}

resource "hcloud_server" "web" {
  name        = "web"
  imaage      = "ubuntu-20.04"
  server_type = "cx11"
  location    = "nbg1"
  ssh_keys = [
    hcloud_ssh_key.default.id
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.ssh_private_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    script = "provision-ubuntu.sh"
  }

}

output "web_ip" {
  value = hcloud_server.web.ipv4_address
}
