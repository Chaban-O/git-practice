# Вказуємо провайдер і регіон AWS
provider "aws" {
  region = var.aws_region
}

# Додаємо ваш SSH ключ
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub") # Вкажіть шлях до вашого публічного SSH ключа
}

# Виклик модуля secrets
module "secrets" {
  source = "./modules/secrets"
  secret_name = "my-test-secret-key-v9"
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

# Отримуємо поточну інформацію про аккаунт AWS, account id
data "aws_caller_identity" "current" {}
