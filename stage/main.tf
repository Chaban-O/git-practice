# Вказуємо провайдер і регіон AWS
provider "aws" {
  region = var.aws_region
}

# Додаємо ваш SSH ключ
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub") # Вкажіть шлях до вашого публічного SSH ключа
}

# Імпортуємо існуючий в AWS VPC ()
resource "aws_vpc" "my_vpc" {
  tags = {
    Name = "my-existing-vpc"
  }
}

# Імпортуємо існуючу сабнет маску з списку сабнетс
resource "aws_subnet" "my_subnet_1" {
  vpc_id            = "vpc-0f0cac06dbc6b8429"
  cidr_block        = "172.31.16.0/20"  # Можете використовувати будь-який CIDR блок спочатку
  availability_zone = "us-east-1d"
  tags = {
    Name = "My-Subnet-1"
  }
}

# Імпортуємо існуючу сабнет маску з списку сабнетс
resource "aws_subnet" "my_subnet_2" {
  vpc_id            = "vpc-0f0cac06dbc6b8429"
  cidr_block        = "172.31.0.0/20"  # Замість цього параметру будуть взяті реальні значення при імпорті
  availability_zone = "us-east-1b"
  tags = {
    Name = "My-Subnet-2"
  }
}

# Імпортуємо існуючу сабнет маску з списку сабнетс
resource "aws_subnet" "my_subnet_3" {
  vpc_id            = "vpc-0f0cac06dbc6b8429"
  cidr_block        = "172.31.64.0/20"
  availability_zone = "us-east-1f"
  tags = {
    Name = "My-Subnet-3"
  }
}

# Виклик модуля secrets
module "secrets" {
  source = "./modules/secrets"
  secret_name = "my-test-secret-key-v28"
  password_length = 16
  recovery_window_in_days = 7
}

# Виклик модуля Security group
module "aws_security_group" {
  source = "./modules/security-group"
}

# Виклик модуля IAM role
module "iam_role" {
  source = "./modules/iam_role"
  instance_profile_name = "ec2_secret_manager_role"
}

# Виклик модуля Application Load Balancer
module "alb" {
  source = "./modules/alb"
  lb_name           = "test-alb"
  security_group_ids = [module.aws_security_group.allow_ssh_http_https]
  subnet_ids = [
    aws_subnet.my_subnet_1.id,
    aws_subnet.my_subnet_2.id,
    aws_subnet.my_subnet_3.id
  ]
  target_group_name = "test-tg"
  health_check_port = 80
  vpc_id            = aws_vpc.my_vpc.id
  target_group_protocol = "HTTP"
  autoscaling_group = module.autoscaling.asg_name
}

# Виклик EC2 модуля
module "ec2_instance" {
  source = "./modules/ec2-instance"
  ami = local.ami_name
  instance_type = "t2.micro"
  instance_name = "MyTerraformInstance"
  ebs_size = 10
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [module.aws_security_group.allow_ssh_http_https]
  instance_profile_name = module.iam_role.instance_profile_name
  secret_id = module.secrets.secret_id
  aws_region = var.aws_region
}

#Виклик модуля Autoscaling group
module "autoscaling" {
  source = "./modules/autoscaling"
  ami_id = local.ami_name
  aws_lb_target_group_arn = module.alb.target_group_arn
  instance_security_group = module.aws_security_group.allow_ssh_http_https
  instance_type = module.ec2_instance.instance_type
  subnets = [
    aws_subnet.my_subnet_1.id,
    aws_subnet.my_subnet_2.id,
    aws_subnet.my_subnet_3.id
  ]
  desired_capacity = 2
  max_size = 3
  min_size = 1
}

# Отримуємо поточну інформацію про аккаунт AWS, account id
data "aws_caller_identity" "current" {}
