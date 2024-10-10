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

output "private_cidrs" {
  description = "The CIDR blocks of the private subnets"
  value       = { for subnet in aws_subnet.private : subnet.id => subnet.cidr_block }
}

output "db_cidrs" {
  description = "The CIDR blocks of the DB subnets"
  value       = { for subnet in aws_subnet.db_subnet : subnet.id => subnet.cidr_block }
}


output "aws_region" {
  description = "Current Region"
  value = var.aws_region
}

output "public_route_table_id" {
  description = "The route table ID for the private subnets"
  value       = aws_route_table.public_subnet_rt.id
}

output "private_route_table_id" {
  description = "The route table ID for the private subnets"
  value       = aws_route_table.private_subnet_rt.id
}

output "db_route_table_id" {
  description = "The route table ID for the DB subnets"
  value       = aws_route_table.db_subnet_rt.id
}

