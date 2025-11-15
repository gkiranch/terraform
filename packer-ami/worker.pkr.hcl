packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.0"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.0"
    }
  }
}

variable "region"      { type = string, default = "us-east-1" }
variable "ssh_user"    { type = string, default = "ec2-user" }   # ubuntu for Ubuntu
variable "source_ami_filters" {
  type = map(string)
  default = {
    owners      = "137112412989"         # Amazon Linux
    name        = "al2023-ami-*-x86_64"
    virtualization-type = "hvm"
    root-device-type    = "ebs"
  }
}

source "amazon-ebs" "worker" {
  region                  = var.region
  instance_type           = "t3.medium"
  ssh_username            = var.ssh_user
  ami_name                = "k8s-worker-{{timestamp}}"
  ami_description         = "Kubernetes worker: chrony, containerd, kubelet/kubeadm/kubectl"
  force_deregister        = false
  force_delete_snapshot   = false

  source_ami_filter {
    filters = {
      name                = var.source_ami_filters["name"]
      virtualization-type = var.source_ami_filters["virtualization-type"]
      root-device-type    = var.source_ami_filters["root-device-type"]
    }
    owners      = [var.source_ami_filters["owners"]]
    most_recent = true
  }

  tags = {
    Name  = "k8s-worker"
    Role  = "k8s-worker"
    Built = timestamp()
  }
}

build {
  name    = "k8s-worker-ami"
  sources = ["source.amazon-ebs.worker"]

  provisioner "ansible" {
    playbook_file = "ntp+k8s.yml"
    extra_arguments = [
      "-e", "kubernetes_version=1.30"
    ]
  }

  post-processor "manifest" {
    output = "packer-manifest.json"
  }
}