variable "subnets" {
  description = "Список підмереж для AutoScaling"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID для EC2 інстансів"
  type        = string
}

variable "instance_type" {
  description = "Тип інстанса EC2"
  type        = string
}

variable "desired_capacity" {
  description = "Бажана кількість інстансів"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Максимальна кількість інстансів"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Мінімальна кількість інстансів"
  type        = number
  default     = 1
}

variable "instance_security_group" {
  description = "Security Group для EC2 інстансів"
  type        = string
}

variable "aws_lb_target_group_arn" {
  description = "(Amazon Resource Name) групи цілей для балансувальника навантаження (Load Balancer) в AWS"
  type        = string
}