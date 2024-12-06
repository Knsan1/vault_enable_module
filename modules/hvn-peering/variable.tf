# hvn_vpc_peering_module/variables.tf

variable "aws_region" {
  description = "The AWS region where the VPC is located"
  type        = string
}

variable "peer_account_id" {
  description = "The AWS account ID for peering"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

# variable "private_subnet_ids" {
#   description = "The IDs of the private subnets"
#   type        = list(string)
# }

# variable "db_subnet_ids" {
#   description = "The IDs of the DB subnets"
#   type        = list(string)
# }

variable "private_subnet_ids" {
  description = "Map of private subnet IDs"
  type        = map(string)
}

variable "db_subnet_ids" {
  description = "Map of database subnet IDs"
  type        = map(string)
}


variable "private_route_table_id" {
  description = "The route table ID for the private subnets"
  type        = string
}

variable "db_route_table_id" {
  description = "The route table ID for the DB subnets"
  type        = string
}

variable "private_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = map(string)
}

variable "db_cidrs" {
  description = "The CIDR blocks for the DB subnets"
  type        = map(string)
}

variable "hvp_vault_cluster" {
  description = "Vault cluster information"
  type = object({
    hvn_id         = string
    hvn_self_link  = string
    hvn_cidr_block = string
  })
}
