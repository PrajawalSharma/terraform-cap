resource "null_resource" "null_copy_ssh" {
    
  connection {
    type = "ssh"
    host = azurerm_linux_virtual_machine.example.public_ip_address
    user = "adminuser"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
        "curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64",
        "chmod +x ./kind",
        "sudo mv ./kind /usr/local/bin/kind",
        "sudo apt-get install -y docker.*",
        "kind create cluster"
    ]
  }
}

