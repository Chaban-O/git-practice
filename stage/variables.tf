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