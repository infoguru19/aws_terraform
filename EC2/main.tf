provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "test" {
  ami           = var.ami_id
  instance_type = "t2.medium"

  tags = {
    Name = "Terraform-EC2"
  }
}