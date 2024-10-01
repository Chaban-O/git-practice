output "secret_name" {
  value = aws_secretsmanager_secret.my_test_secret.name
}
output "secret_id" {
  value = aws_secretsmanager_secret_version.my_secret_version.secret_id
}