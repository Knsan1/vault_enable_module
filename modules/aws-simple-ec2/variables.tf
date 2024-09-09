variable "region" {
  description = "The AWS region where the EC2 instance will be created."
  type        = string
  default     = "us-west-2"
}

variable "ami" {
  description = "The ID of the AMI to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to create."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC the instance in"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in."
  type        = string
}

variable "instance_name" {
  description = "The name tag for the EC2 instance."
  type        = string
  default     = "example-instance"
}
