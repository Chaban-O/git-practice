variable "engine_type" {
  description = "Тип бази даних для RDS (наприклад, 'mysql', 'postgres', 'oracle-ee')."
  type = string
}

variable "db_instance_class" {
  description = "Клас екземпляра бази даних RDS, що визначає ресурси, такі як пам'ять і процесор (наприклад, 'db.t3.micro')."
  type = string
}

variable "allocated_storage" {
  description = "Розмір пам'яті для RDS у гігабайтах (наприклад, 20 для 20GB)."
  type = number
}

variable "rds_db_name" {
  description = "Назва бази даних, яка буде створена в RDS."
  type = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to assign to the instance"
  type        = list(string)
}

variable "cluster_identifier" {
  description = "Унікальний ідентифікатор кластера для RDS, який слугує для його ідентифікації в рамках AWS."
  type = string
}

variable "engine_version" {
  description = "Версія движка бази даних для RDS (наприклад, '5.7' для MySQL або '12' для PostgreSQL)."
  type = string
}