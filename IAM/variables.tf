variable "aws_region" {
  default = "us-east-1"
}

variable "user_name" {
  description = "Name of the IAM user"
  default     = "terraform-user"
}

variable "group_name" {
  description = "Name of the IAM group"
  default     = "terraform-group"
}
