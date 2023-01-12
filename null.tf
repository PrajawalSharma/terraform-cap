resource "null_resource" "null_copy_ssh" {
    
    depends_on = [
    azurerm_linux_virtual_machine.example
  ]
    
  connection {
    type = "ssh"
    host = azurerm_linux_virtual_machine.example.public_ip_address
    user = "adminuser"
    private_key = file("/var/lib/jenkins/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
        "curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64",
        "chmod +x ./kind",
        "sudo mv ./kind /usr/local/bin/kind",
        "sudo apt-get update",
        "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
        "sudo mkdir -p  /etc/apt/keyrings",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
        " echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
        "sudo apt-get update",
        "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin",
        "sudo kind create cluster",
        "sudo apt-get install -y ca-certificates curl",
        "sudo apt-get install -y apt-transport-https",
        "sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg",
        "echo \"deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee /etc/apt/sources.list.d/kubernetes.list",
        "sudo apt-get update",
        "sudo apt-get install -y kubectl",
        "curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3",
        "chmod 700 get_helm.sh",
        "./get_helm.sh",
        "sudo kubectl get nodes",
        "curl -L https://istio.io/downloadIstio | sh -",
        "cd istio-1.16.1/bin",
        "sudo cp istioctl /usr/bin/",
        "sudo istioctl install --set profile=demo -y"
    ]
  }
}

