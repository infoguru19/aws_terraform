provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "dev_S3" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = "TerraformS3Bucket"
    Environment = "Dev"
  }
}