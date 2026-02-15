#--------------------------------------------------------------
# DATA SOURCE: Get latest Amazon Linux 2023 AMI
#--------------------------------------------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#--------------------------------------------------------------
# VPC
# All other resources depend on this
#--------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#--------------------------------------------------------------
# INTERNET GATEWAY
# Implicit dependency on VPC (references aws_vpc.main.id)
#--------------------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # ◄── Implicit dependency!

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#--------------------------------------------------------------
# PUBLIC SUBNET
# Implicit dependency on VPC
#--------------------------------------------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id # ◄── Implicit dependency!
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

#--------------------------------------------------------------
# ROUTE TABLE
# Implicit dependency on VPC and Internet Gateway
#--------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id # ◄── Implicit dependency!

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id # ◄── Implicit dependency!
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

#--------------------------------------------------------------
# ROUTE TABLE ASSOCIATION
# Associates subnet with route table
#--------------------------------------------------------------
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#--------------------------------------------------------------
# SECURITY GROUP
# Allows SSH access
#--------------------------------------------------------------
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main.id # ◄── Implicit dependency!

  # Inbound: Allow SSH
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: Allow all
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

#--------------------------------------------------------------
# EC2 INSTANCE
# Depends on subnet and security group
#--------------------------------------------------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id        # ◄── Implicit dependency!
  vpc_security_group_ids = [aws_security_group.ec2.id] # ◄── Implicit dependency!

  tags = {
    Name = "${var.project_name}-ec2"
  }
}