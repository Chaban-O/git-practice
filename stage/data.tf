# Імпортуємо ami packer profile
data "aws_ami" "my_packer_ami" {
  most_recent = true
  owners = ["self"]
}

# Імпортуємо vpc, знаходячи його на aws по назві
data "aws_vpc" "default" {
  default = true
}

# Імпортуємо subnet, знаходячи її на aws по id
data "aws_subnet" "my-subnet-1" {
  filter {
    name = "subnet-id"
    values = ["subnet-0a3634e97be8618b5"]
  }
}

# Імпортуємо subnet, знаходячи її на aws по id
data "aws_subnet" "my-subnet-2" {
  filter {
    name = "subnet-id"
    values = ["subnet-0c01848d938e6913e"]
  }
}

# Імпортуємо subnet, знаходячи її на aws по id
data "aws_subnet" "my-subnet-3" {
  filter {
    name = "subnet-id"
    values = ["subnet-028e038513b3eacaa"]
  }
}

# Імпортуємо subnet, знаходячи її на aws по id
data "aws_subnet" "my-subnet-4" {
  filter {
    name = "subnet-id"
    values = ["subnet-0f4e327fe37469d32"]
  }
}

# Імпортуємо subnet, знаходячи її на aws по id
data "aws_subnet" "my-subnet-5" {
  filter {
    name = "subnet-id"
    values = ["subnet-0924f0624c03a340a"]
  }
}

# Імпортуємо subnet, знаходячи її на aws по id
data "aws_subnet" "my-subnet-6" {
  filter {
    name = "subnet-id"
    values = ["subnet-0659fa44af1a31fbc"]
  }
}

# Отримуємо поточну інформацію про аккаунт AWS, account id
data "aws_caller_identity" "current" {}

# Приклад як можна імпортувати, але краще не робити
# Імпортуємо існуючий в AWS VPC (ізольоване віртуальне середовище в хмарі, в якому ви можете запускати ресурси
# такі як EC2 інстанси, RDS бази даних, та інші сервіси AWS)
# terraform import aws_vpc.my_vpc vpc-0bbf330c7549826b9
# resource "aws_vpc" "my_vpc" {
#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     Name = "my-existing-vpc"
#   }
# }
# Імпортуємо існуючу сабнет маску з списку сабнетс
# terraform import aws_subnet.my_subnet_1 subnet-0917ae27ff5541e09
# resource "aws_subnet" "my_subnet_1" {
#   vpc_id            = "vpc-0bbf330c7549826b9"
#   cidr_block        = "172.31.80.0/20"  # Можете використовувати будь-який CIDR блок спочатку
#   availability_zone = "us-east-1c"
#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     Name = "My-Subnet-1"
#   }
# }
#
# # Імпортуємо існуючу сабнет маску з списку сабнетс
# # terraform import aws_subnet.my_subnet_2 subnet-0f386bb962e3c2ab3
# resource "aws_subnet" "my_subnet_2" {
#   vpc_id            = "vpc-0bbf330c7549826b9"
#   cidr_block        = "172.31.0.0/20"  # Замість цього параметру будуть взяті реальні значення при імпорті
#   availability_zone = "us-east-1b"
#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     Name = "My-Subnet-2"
#   }
# }
#
# # Імпортуємо існуючу сабнет маску з списку сабнетс
# # terraform import aws_subnet.my_subnet_3 subnet-03eeb73542ce1ac39
# resource "aws_subnet" "my_subnet_3" {
#   vpc_id            = "vpc-0bbf330c7549826b9"
#   cidr_block        = "172.31.32.0/20"
#   availability_zone = "us-east-1a"
#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     Name = "My-Subnet-3"
#   }
# }