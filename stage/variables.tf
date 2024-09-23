# Ручний вивід. Якщо доступ до AWS Organisations API обмежений або не бажаний, можна створити окремий файл з інформацією про акк, та викоростовувати його
variable "account_name" {
  description = "The name of the AWS account"
  type        = string
  default     = "admin"  # Вкажіть ім'я акаунта вручну
}

variable "aws_region" {
  description = "The name of the AWS region"
  type = string
  default = "us-east-1" # Замініть на ваш регіон
}

variable "ebs_size" {
  description = "EBS volume size"
  type = number
  default = 10
}

locals {
  instance_tag = "MyTerraformInstance"
}

variable "docker_install" {
  description = "Docker package install"
  type = list(string)
  default = [
    "set -ex",
    "sudo apt-get update -y",
    "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
    "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
    "UBUNTU_CODENAME=$(lsb_release -cs) && sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable\" -y",
    "sudo apt-get update -y",
    "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
    "sudo usermod -aG docker ubuntu",
    "sudo systemctl start docker",
    "sudo systemctl enable docker",
    "sudo systemctl restart docker",
    ]
}

variable "docker_compose_install" {
  description = "Docker compose install"
  type = list(string)
  default = [
    "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
    "sudo chmod +x /usr/local/bin/docker-compose",
  ]
}

###Security group setting###

###ingress####
variable "ssh_cidr" {
  description = "CIDR block for ssh access"
  type = list(string)
  default = ["79.110.128.238/32"] # Замість цього значення можна задати список IP-адрес
}

variable "http_cidr" {
  description = "CIDR block for HTTP access"
  type = list(string)
  default = ["0.0.0.0/0"] # Замість цього значення можна задати список IP-адрес
}

variable "https_cidr" {
  description = "CIDR block for HTTPS access"
  type = list(string)
  default = ["0.0.0.0/0"] # Замість цього значення можна задати список IP-адрес
}

locals {
  allowed_ports = [
    {from_port = 22, to_port = 22, protocol = "tcp", cidr = var.ssh_cidr},
    {from_port = 80, to_port = 80, protocol = "tcp", cidr = var.http_cidr},
    {from_port = 443, to_port=443, protocol = "tcp", cidr = var.https_cidr}
  ]
 }

##egress###
variable "egress_rules" {
  description = "List of egress rules with ports and CIDR blocks"
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}