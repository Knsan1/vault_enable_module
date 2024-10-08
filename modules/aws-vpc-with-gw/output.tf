output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "db_subnet_ids" {
  description = "The IDs of the DB subnets"
  value       = aws_subnet.db_subnet[*].id
}

output "aws_region" {
  description = "Current Region"
  value = var.aws_region
}