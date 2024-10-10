variable "engine_type" {
  description = ""
  type = string
}

variable "db_instance_class" {
  description = ""
  type = string
}

variable "allocated_storage" {
  description = ""
  type = number
}

variable "rds_db_name" {
  description = ""
  type = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to assign to the instance"
  type        = list(string)
}

variable "cluster_identifier" {
  description = ""
  type = string
}

variable "engine_version" {
  description = ""
  type = string
}