# # Data source to retrieve AWS account ID
# data "aws_caller_identity" "current" {}

# # Data source to retrieve current AWS region
# data "aws_region" "current" {}

# # Data source to get the owner ID of the VPC
# data "aws_vpc" "selected" {
#   id = module.vpc.vpc_id
# }

# # Data source to get the region of the VPC
# data "aws_arn" "vpc_region" {
#   arn = data.aws_vpc.selected.arn
# }

# # Data source for Private Subnet
# data "aws_subnets" "private" {
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }

#   tags = {
#     Name = "private*"
#   }
# }

# # Data source for DB Subnet
# data "aws_subnets" "db" {
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }

#   tags = {
#     Name = "db*"
#   }
# }

# # Creating a map from subnet IDs for private subnets
# locals {
#   private_subnet_ids = { for id in data.aws_subnets.private.ids : id => id }
# }

# # Creating a map from subnet IDs for DB subnets
# locals {
#   db_subnet_ids = { for id in data.aws_subnets.db.ids : id => id }
# }

# ###For Private Subnet
# data "aws_subnets" "private" {
#   depends_on = [module.vpc]
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }

#   tags = {
#     Name = "private*"
#   }
# }

# data "aws_subnet" "private" {
#   depends_on = [module.vpc]
#   for_each = toset(data.aws_subnets.private.ids)
#   id       = each.value
# }

# ###For DB Subnet
# data "aws_subnets" "db" {
#   depends_on = [module.vpc]
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }

#   tags = {
#     Name = "db*"
#   }
# }

# data "aws_subnet" "db" {
#   depends_on = [module.vpc]
#   for_each = toset(data.aws_subnets.db.ids)
#   id       = each.value
# }

# data "aws_route_table" "private_rt" {
#   subnet_id = data.aws_subnets.private.ids[0]
# }

# data "aws_route_table" "db_rt" {
#   subnet_id = data.aws_subnets.db.ids[0]
# }