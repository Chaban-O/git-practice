packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_access_key" {
  type = string
  default = ""
}

variable "aws_secret_key" {
  type = string
  default = ""
}

variable "ssh_username" {
  default = "ubuntu"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_name" {
  default = "ami-0a0e5d9c7acc336f1"
}

variable "aws_region" {
  default = "us-east-1" # Замініть на ваш регіон
}

source "amazon-ebs" "example" {
  ami_description             = "AMI with Nginx that displays hostname"
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  region                      = var.aws_region
  source_ami                  = var.ami_name
  instance_type               = var.instance_type
  ssh_username                = var.ssh_username
  ami_name                    = "packer-base-{{timestamp}}"
  associate_public_ip_address = true

  tags = {
    Name = "Packer-created-AMI"
  }

  run_tags = {
    Name = "Packer Builder Instance"
  }
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "file" {
    source = "/home/chaban/PycharmProjects/git-practice/scripts/install-nginx.sh"
    destination = "/home/ubuntu/install-nginx.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /home/ubuntu/install-nginx.sh",
      "bash /home/ubuntu/install-nginx.sh"
    ]
  }
}