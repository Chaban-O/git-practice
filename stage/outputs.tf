output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_account_name_manual" {
  value = var.account_name
}
