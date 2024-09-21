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

variable "instance_tags" {
  description = "Instance tags"
  type = string
  default = "MyTerraformInstance"
}

variable "ebs_size" {
  description = "EBS volume size"
  type = number
  default = 10
}

variable "docker_install" {
  description = "Docker install package"
  type = list(string)
  default = [
    "sudo apt-get update",
    "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
    "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
    "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"]
}

variable "docker_compose_install" {
  description = "Docker compose install"
  type = list(string)
  default = [
    "sudo apt-get update",
    "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
    "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
    "sudo chmod +x /usr/local/bin/docker-compose",
  ]
}
