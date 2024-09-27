variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key name to access the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to assign to the instance"
  type        = list(string)
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "ebs_size" {
  description = "EBS volume size"
  type = number
}

variable "instance_profile_arn" {
  type        = string
  description = "IAM Instance profile ARN"
}

variable "secret_id" {
  description = "Name of the secret id"
  type = string
}

variable "aws_region" {
  description = "name of the AWS region"
  type = string
}