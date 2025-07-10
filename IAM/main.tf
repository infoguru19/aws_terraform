provider "aws" {
  region = var.aws_region
}

# IAM Group
resource "aws_iam_group" "dev_group" {
  name = var.group_name
}

# IAM Policy Attachment (e.g., Read-only access to S3)
resource "aws_iam_group_policy_attachment" "group_policy_attach" {
  group      = aws_iam_group.dev_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# IAM User
resource "aws_iam_user" "dev_user" {
  name = var.user_name
}

# Add user to group
resource "aws_iam_user_group_membership" "group_membership" {
  user = aws_iam_user.dev_user.name
  groups = [
    aws_iam_group.dev_group.name
  ]
}

# Optional: IAM Role with trust policy
resource "aws_iam_role" "ec2_role" {
  name = "EC2AssumeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
