# hvn_vpc_peering_module/main.tf

# HVN peering with the VPC
resource "hcp_aws_network_peering" "hvn_to_vpc" {
  # depends_on      = [var.hvp_vault_cluster]
  
  hvn_id          = var.hvp_vault_cluster.hvn_id
  peering_id      = "hvn-to-vpc-peer"
  peer_vpc_id     = var.vpc_id
  peer_account_id = var.peer_account_id
  peer_vpc_region = var.aws_region
}

# Accept VPC peering connection
resource "aws_vpc_peering_connection_accepter" "accept_hvn_to_vpc" {
  vpc_peering_connection_id = hcp_aws_network_peering.hvn_to_vpc.provider_peering_id
  auto_accept               = true
}

# HVN Routes for Private Subnet
resource "hcp_hvn_route" "hvn_to_private" {
  for_each         = toset(var.private_subnet_ids)
  hvn_link         = var.hvp_vault_cluster.hvn_self_link
  hvn_route_id     = each.value
  destination_cidr = var.private_cidrs[each.value]
  target_link      = hcp_aws_network_peering.hvn_to_vpc.self_link
}

# HVN Routes for DB Subnet
resource "hcp_hvn_route" "hvn_to_db" {
  for_each         = toset(var.db_subnet_ids)
  hvn_link         = var.hvp_vault_cluster.hvn_self_link
  hvn_route_id     = each.value
  destination_cidr = var.db_cidrs[each.value]
  target_link      = hcp_aws_network_peering.hvn_to_vpc.self_link
}

# Private Subnet to HVN Route
resource "aws_route" "private_to_hvn" {
  route_table_id            = var.private_route_table_id
  destination_cidr_block    = var.hvp_vault_cluster.hvn_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accept_hvn_to_vpc.id
}

# DB Subnet to HVN Route
resource "aws_route" "db_to_hvn" {
  route_table_id            = var.db_route_table_id
  destination_cidr_block    = var.hvp_vault_cluster.hvn_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accept_hvn_to_vpc.id
}
