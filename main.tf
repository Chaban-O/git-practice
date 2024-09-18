# Вказуємо провайдер і регіон AWS
provider "aws" {
  region = "us-east-1" # Замініть на ваш регіон
}

# Додаємо ваш SSH ключ
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub") # Вкажіть шлях до вашого публічного SSH ключа
}

# Створюємо Security Group з необхідними правилами
resource "aws_security_group" "allow_ssh_http_https" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP, and HTTPS traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["79.110.128.251/32"] # Вкажіть вашу IP адресу
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "MyTerraformInstance"
  }

  # Вказуємо параметри для EBS
  root_block_device {
    volume_size = 10
  }

  # Додаємо Provisioner для встановлення Docker та Docker Compose
  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa") # Вкажіть шлях до вашого приватного SSH ключа
      host        = self.public_ip
    }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
    ]
  }

  # Додаємо публічну IP адресу
  associate_public_ip_address = true
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
