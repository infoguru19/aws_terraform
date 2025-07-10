variable "aws_region" {
  description = "AWS region to deploy in"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet to launch instances in"
  type        = string
}

variable "security_group_id" {
  description = "Security group to associate with EC2 instances"
  type        = string
}

variable "instances" {
  description = "Map of instances with environment keys"
  type = map(string)
  default = {
    Dev  = "Development"
    UAT  = "User Acceptance Testing"
    PRD  = "Production"
  }
}
