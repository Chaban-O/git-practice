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

locals {
  ami_name = "ami-0a0e5d9c7acc336f1"
}