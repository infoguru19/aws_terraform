variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Version of the database engine"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "mydatabase"
}

variable "allocated_storage" {
  description = "Size of database"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Max Size of database"  # Help in Autoscaling
  type        = number
  default     = 100
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}
