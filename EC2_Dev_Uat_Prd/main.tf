provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "env_instances" {
  for_each = var.instances

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = each.key
    Environment = each.key
  }
}
