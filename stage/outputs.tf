output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_account_name_manual" {
  value = var.account_name
}

output "instance_public_ip" {
  value = module.ec2_instance.instance_public_ip
}