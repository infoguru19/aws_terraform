provider "aws" {
  region = var.aws_region
}

resource "aws_db_instance" "default" {
  identifier            = "terraform-rds-db"
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  db_name               = var.db_name
  username              = var.db_username
  password              = var.db_password
  skip_final_snapshot   = true
  publicly_accessible   = true

  tags = {
    Name = "TerraformRDS"
  }
}
