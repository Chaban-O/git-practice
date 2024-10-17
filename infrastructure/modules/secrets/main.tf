# Генерація випадкового пароля
resource "random_password" "my_random_password" {
  length  = var.password_length
  special = true
}

# Додавання секрету в AWS Secret Manager
resource "aws_secretsmanager_secret" "my_test_secret" {
  name = var.secret_name
  recovery_window_in_days = var.recovery_window_in_days
}

# Збереження пароля в AWS Secret Manager
resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_test_secret.id
  secret_string = random_password.my_random_password.result
}
