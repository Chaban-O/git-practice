output "instance_profile_arn" {
  description = "Amazon Resource Name (ARN), який представляє IAM Instance Profile"
  value = aws_iam_instance_profile.ec2_instance_profile.arn
}

output "role_name" {
  value = aws_iam_role.ec2_role.name
}