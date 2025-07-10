provider "aws" {
  region = "us-east-1"
}

# VPC 1
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "VPC1" }
}

resource "aws_subnet" "vpc1_subnet" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "VPC1-Subnet" }
}

# VPC 2
resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  tags = { Name = "VPC2" }
}

resource "aws_subnet" "vpc2_subnet" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "VPC2-Subnet" }
}

# VPC Peering
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.vpc1.id
  peer_vpc_id   = aws_vpc.vpc2.id
  auto_accept   = true

  tags = {
    Name = "VPC1-to-VPC2"
  }
}

# Route Tables for VPC1
resource "aws_route_table" "vpc1_rt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block                = aws_vpc.vpc2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = { Name = "VPC1-RouteTable" }
}

resource "aws_route_table_association" "vpc1_rta" {
  subnet_id      = aws_subnet.vpc1_subnet.id
  route_table_id = aws_route_table.vpc1_rt.id
}

# Route Tables for VPC2
resource "aws_route_table" "vpc2_rt" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block                = aws_vpc.vpc1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = { Name = "VPC2-RouteTable" }
}

resource "aws_route_table_association" "vpc2_rta" {
  subnet_id      = aws_subnet.vpc2_subnet.id
  route_table_id = aws_route_table.vpc2_rt.id
}

# Security Group (open ICMP and SSH for testing)
resource "aws_security_group" "allow_icmp_ssh" {
  name        = "allow_icmp_ssh"
  description = "Allow ping and SSH"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Duplicate SG for VPC2
resource "aws_security_group" "allow_icmp_ssh_vpc2" {
  name        = "allow_icmp_ssh_vpc2"
  description = "Allow ping and SSH"
  vpc_id      = aws_vpc.vpc2.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance in VPC1
resource "aws_instance" "vpc1_ec2" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2 (update if needed)
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc1_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_icmp_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "VPC1-EC2"
  }
}

# EC2 Instance in VPC2
resource "aws_instance" "vpc2_ec2" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc2_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_icmp_ssh_vpc2.id]
  associate_public_ip_address = true

  tags = {
    Name = "VPC2-EC2"
  }
}
