# Terraform VPC + EC2 Module

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20EC2-FF9900?logo=amazonaws)](https://aws.amazon.com/)

## Overview

Production-ready Terraform module that creates:

- ✅ VPC with DNS support
- ✅ Public subnet with auto-assign public IP
- ✅ Internet Gateway
- ✅ Route Table with internet access
- ✅ Security Group (SSH access)
- ✅ EC2 Instance (Amazon Linux 2023)

## Architecture
┌─────────────────────────────────────────────────────────────┐
│ VPC (10.0.0.0/16) │
│ │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Public Subnet (10.0.1.0/24) │ │
│ │ │ │
│ │ ┌─────────────────────────────────────────────┐ │ │
│ │ │ EC2 Instance (t3.micro) │ │ │
│ │ │ Amazon Linux 2023 │ │ │
│ │ │ Security Group: SSH (22) │ │ │
│ │ └─────────────────────────────────────────────┘ │ │
│ │ │ │
│ └─────────────────────────────────────────────────────┘ │
│ │
│ Internet Gateway ◄──────────────────────────────────────► │
│ │
└─────────────────────────────────────────────────────────────┘


## Usage

```hcl
module "vpc_ec2" {
  source = "github.com/sagar3414/terraform-vpc-ec2-module"

  project_name       = "my-app"
  environment        = "dev"
  aws_region         = "us-east-1"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  instance_type      = "t3.micro"
}
Inputs
Name	Description	Type	Default
aws_region	AWS region	string	us-east-1
environment	Environment name	string	dev
project_name	Project name	string	platform-vpc
vpc_cidr	VPC CIDR block	string	10.0.0.0/16
public_subnet_cidr	Public subnet CIDR	string	10.0.1.0/24
instance_type	EC2 instance type	string	t3.micro
Outputs
Name	Description
vpc_id	VPC ID
vpc_cidr	VPC CIDR block
public_subnet_id	Public subnet ID
ec2_instance_id	EC2 instance ID
ec2_public_ip	EC2 public IP
ec2_public_dns	EC2 public DNS
security_group_id	Security group ID
Key Concepts Demonstrated
Provider Configuration - AWS provider with default tags
Data Sources - Dynamic AMI lookup
Implicit Dependencies - Resource references
Resource Relationships - VPC → Subnet → EC2
Author
Sagar 

License
MIT License
