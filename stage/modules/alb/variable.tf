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

variable "health_check_port" {
    description = "Port for the target group"
    type        = number
}

variable "vpc_id" {
    description = "VPC ID"
    type        = string
}

variable "target_group_protocol" {
    description = "Target protocols"
    type = string
}

variable "autoscaling_group" {
    description = "autoscaling_group name"
    type = string
}