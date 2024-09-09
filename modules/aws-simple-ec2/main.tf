provider "aws" {
  region = var.region
}

# Create Security Group
resource "aws_security_group" "instance" {
  name_prefix = "${var.region}-instance-sg"
  description = "Allow inbound SSH traffic"
  
  # Make sure the security group is created within the same VPC as the subnet
  vpc_id = var.vpc_id

  # Allow inbound SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound ICMP traffic
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.region}-instance-sg"
  }
}

# Create EC2 Instance
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  
  # Ensure that the security group belongs to the same VPC as the subnet
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = var.instance_name
  }
}