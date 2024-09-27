###Пояснення###
#aws_iam_role: Створює роль, яку EC2 інстанс може "асоціювати" для доступу до AWS ресурсів.
#aws_iam_policy: Створює політику, яка дозволяє отримувати секрети з Secret Manager.
#aws_iam_role_policy_attachment: Прикріплює політику до ролі.
#aws_iam_instance_profile: Створює instance profile, необхідний для прикріплення ролі до EC2 інстансу.

# Створення IAM ролі для екземпляра EC2
# Тут створюється IAM роль для EC2. Використовується політика AssumeRole, яка дозволяє EC2 інстансу "асоціювати" цю IAM роль для доступу до AWS ресурсів
resource "aws_iam_role" "ec2_role" {
  name = var.instance_profile_name

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
  name = "${var.instance_profile_name}-secret-manager-access"
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
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secret_manager_policy.arn
}

# Для того, щоб EC2 інстанс міг використовувати IAM роль, створюємо Instance Profile і асоціюємо його з роллю.
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.instance_profile_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}
