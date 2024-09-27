resource "aws_instance" "web" {
  ami           = var.ami # Виберіть підходящий AMI для Ubuntu
  instance_type = var.instance_type

  # Додаємо Security Group і SSH ключ
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids

  # Додаємо тег для ідентифікації
  tags = {
    Name = var.instance_name
  }

  # Встановлює для EC2-інстансу IAM роль через Instance Profile.
  iam_instance_profile = var.instance_profile_name

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

  provisioner "file" {
    source = "/home/chaban/PycharmProjects/git-practice/stage/scripts/install_docker_package.sh"
    destination = "/home/ubuntu/install_docker_package.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /home/ubuntu/install_docker_package.sh"
    ]
  }

  user_data = <<-EOF
    #!/bin/bash
    set -ex
    sudo apt install unzip curl -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    echo "aws --version"

    SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id ${var.secret_id} --query SecretString --output text --region ${var.aws_region})

    echo "SECRET=$SECRET_VALUE" >> /home/ubuntu.env
  EOF

  # Додаємо публічну IP адресу
  associate_public_ip_address = true
}