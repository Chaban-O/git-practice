variable "password_length" {
  description = "Length on the password"
  type = number
  default = 16
}

variable "secret_name" {
  description = "The name of the secret"
  type = string
}

variable "recovery_window_in_days" {
  description = "The number of days that AWS Secrets Manager waits before it can delete the secret"
  type = number
}