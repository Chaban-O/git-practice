variable "lb_name" {
    description = "Name of the load balancer"
    type        = string
}

variable "security_group_ids" {
    description = "List of security group IDs"
    type        = list(string)
}

variable "subnet_ids" {
    description = "List of subnet IDs"
    type        = list(string)
}

variable "target_group_name" {
    description = "Name of the target group"
    type        = string
}

variable "target_group_port" {
    description = "Port for the target group"
    type        = number
}

variable "vpc_id" {
    description = "VPC ID"
    type        = string
}

variable "instance_ids" {
    description = "List of EC2 instance IDs to attach to the target group"
    type        = list(string)
}

variable "target_group_protocol" {
    description = "List of target protocols"
    type = list(string)
}
