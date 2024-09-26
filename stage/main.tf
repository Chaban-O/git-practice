# Вказуємо провайдер і регіон AWS
provider "aws" {
  region = var.aws_region
}

# Додаємо ваш SSH ключ
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub") # Вкажіть шлях до вашого публічного SSH ключа
}

# # Генерація випадкового пароля
# resource "random_password" "my_random_password" {
#   length  = 16
#   special = true
# }
#
# # Додавання секрету в AWS Secret Manager
# resource "aws_secretsmanager_secret" "my_test_secret" {
#   name = "my-test-secret-key-v2"
# }
#
# # Збереження пароля в AWS Secret Manager
# resource "aws_secretsmanager_secret_version" "my_secret_version" {
#   secret_id     = aws_secretsmanager_secret.my_test_secret.id
#   secret_string = random_password.my_random_password.result
# }

# Виклик модуля Security group
module "aws_security_group" {
  source = "./modules/security-group"
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
}

# Отримуємо поточну інформацію про аккаунт AWS, account id
data "aws_caller_identity" "current" {}
