# Вказуємо провайдер і регіон AWS
provider "aws" {
  region = var.aws_region
}

# Додаємо ваш SSH ключ
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub") # Вкажіть шлях до вашого публічного SSH ключа
}

# Генерація випадкового пароля
resource "random_password" "my_random_password" {
  length  = 16
  special = true
}

# Додавання секрету в AWS Secret Manager
resource "aws_secretsmanager_secret" "my_test_secret" {
  name = "my-test-secret-key-v2"
}

# Збереження пароля в AWS Secret Manager
resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_test_secret.id
  secret_string = random_password.my_random_password.result
}

# Створюємо Security Group з необхідними правилами
resource "aws_security_group" "allow_ssh_http_https" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP, and HTTPS traffic"

  # Динамічно створюємо ingress правила для SSH, HTTP та HTTPS
  dynamic "ingress" {
    for_each = local.allowed_ports
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  }

# Створюємо EC2 інстанс
resource "aws_instance" "web" {
  ami           = "ami-0a0e5d9c7acc336f1" # Виберіть підходящий AMI для Ubuntu
  instance_type = "t2.micro"

  # Додаємо Security Group і SSH ключ
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http_https.id]

  # Додаємо тег для ідентифікації
  tags = {
    Name = local.instance_tag
  }

  # Вказуємо параметри для EBS
  root_block_device {
    volume_size = var.ebs_size
  }

  # Додаємо Provisioner для встановлення Docker та Docker Compose
  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa") # Вкажіть шлях до вашого приватного SSH ключа
      host        = self.public_ip
    }

#   provisioner "remote-exec" {
#     inline = flatten([
#       var.docker_install,
#       var.docker_compose_install
#     ])
#   }

  provisioner "file" {
    source = "install_docker_package.sh"
    destination = "stage/install_docker_package.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash stage/install_docker_package.sh"
    ]
  }

  # Додаємо публічну IP адресу
  associate_public_ip_address = true
}

# Отримуємо поточну інформацію про акаунт AWS, account id
data "aws_caller_identity" "current" {}
