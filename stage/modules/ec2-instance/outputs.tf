output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value = aws_instance.web.id
}

output "instance_type" {
  value = aws_instance.web.instance_type
}

output "instance_ids" {
  value = aws_instance.web[*].id # Список усіх інстансів
}