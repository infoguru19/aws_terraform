#Create VPC
resource "aws_vpc" "myVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myProd"
  }
}

#Create Internet Gateway: Used to make access your resouce in public 
resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "myGW"
  }
}

#Create Route Table: To route traffic as per configuration 
resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.mygw.id
  }

  tags = {
    Name = "my_route_table"
  }
}

#Create Subnet : Small Segment of big N/W
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.myVPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "mySubnet"
  }
}

#Create Route Table Association
resource "aws_route_table_association" "myRTA" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.my-route-table.id
}

#Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow_Web"
  }
}

#Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

#Assign an elastic IP to the network interface
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.mygw, aws_instance.web-server]
}

#Create ubuntu server and install/enable apache2
resource "aws_instance" "web-server" {
  ami               = "ami-00399ec92321828f5"
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  key_name          = "main-key"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install apache2 -y
  sudo systemctl start apache2
  sudo bash -c 'echo you are very first web server > /var/www/html/index.html'
  EOF

  tags = {
    Name = "WebServerDemo"
  }
}
