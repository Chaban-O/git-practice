# Створення IAM ролі для екземпляра EC2
# Тут створюється IAM роль для EC2. Використовується політика AssumeRole, яка дозволяє EC2 інстансу "асоціювати" цю IAM роль для доступу до AWS ресурсів
resource "aws_iam_role" "ec2_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com" # в полі Principal вказує, що лише EC2 інстанси можуть використовувати цю роль.
      }
    }]
  })
}

# Додаємо політику, яка дозволяє EC2 інстансу отримувати значення секретів з Secrets Manager.
resource "aws_iam_policy" "secret_manager_policy" {
  name = "secret-manager-access"
  description = "Policy to allow access to Secret Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
       "secretsmanager:GetSecretValue" # Дозволяє отримувати значення секрету
      ],
      Resource = "*" # Дозволяє доступ до всіх секретів (можна обмежити конкретними ресурсами)
    }]
  })
}

# Прикріплюємо створену політику до нашої ролі.
resource "aws_iam_role_policy_attachment" "attach_secret_policy" {
  policy_arn = aws_iam_role.ec2_role.arn
  role       = aws_iam_policy.secret_manager_policy.name
}

# Для того, щоб EC2 інстанс міг використовувати IAM роль, створюємо Instance Profile і асоціюємо його з роллю.
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}
