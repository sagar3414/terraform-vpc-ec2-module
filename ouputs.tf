#--------------------------------------------------------------
# VPC Outputs
#--------------------------------------------------------------
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

#--------------------------------------------------------------
# Subnet Outputs
#--------------------------------------------------------------
output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

#--------------------------------------------------------------
# EC2 Outputs
#--------------------------------------------------------------
output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "ec2_public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.web.public_ip
}

output "ec2_public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.web.public_dns
}

#--------------------------------------------------------------
# Security Group Outputs
#--------------------------------------------------------------
output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.ec2.id
}

#--------------------------------------------------------------
# AMI Output
#--------------------------------------------------------------
output "ami_id" {
  description = "AMI ID used for EC2"
  value       = data.aws_ami.amazon_linux.id
}