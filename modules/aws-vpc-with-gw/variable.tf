variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "vault-vpc"
}

variable "public_cidr_block" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_cidr_block" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
}

variable "db_cidr_block" {
  description = "List of CIDR blocks for DB subnets"
  type        = list(string)
  default     = ["10.10.7.0/24", "10.10.8.0/24", "10.10.9.0/24"]
}
