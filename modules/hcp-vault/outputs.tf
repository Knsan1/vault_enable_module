# Outputs file
output "vault_private_endpoint" {
  description = "Vault Cluster Private EndPoint URL"
  value =  hcp_vault_cluster.aws_hcp_vault_cluster.vault_private_endpoint_url
}

output "vault_public_endpoint" {
  description = "Vault Cluster Public EndPoint URL"
  value =  hcp_vault_cluster.aws_hcp_vault_cluster.vault_public_endpoint_url
}

output "vault_namespace" {
  description = "Vault Cluster Namespace"
  value =  hcp_vault_cluster.aws_hcp_vault_cluster.namespace
}

output "vault_version" {
  description = "Vault Version"
  value =  hcp_vault_cluster.aws_hcp_vault_cluster.vault_version
}


output "vault_token_id" {
  description = "Vault token resource ID"
  value =  hcp_vault_cluster_admin_token.master.id
}

output "vault_token_key" {
  description = "Vault Token"
  value =  hcp_vault_cluster_admin_token.master.token
}


output "hvn_id" {
  description = "The ID of the HashiCorp Virtual Network (HVN) used for peering"
  value       = hcp_hvn.aws_hcp_vault_hvn.hvn_id
}

output "hvn_cidr_block" {
  description = "The CIDR block of the HashiCorp Virtual Network (HVN)"
  value       = hcp_hvn.aws_hcp_vault_hvn.cidr_block
}

output "hvn_region" {
  description = "The region where the HashiCorp Virtual Network (HVN) is located"
  value       = hcp_hvn.aws_hcp_vault_hvn.region
}

output "hvn_self_link" {
  description = "The self link of the HashiCorp Virtual Network (HVN) for peering setup"
  value       = hcp_hvn.aws_hcp_vault_hvn.self_link
}

output "hvn_state" {
  description = "The current state of the HashiCorp Virtual Network (HVN)"
  value       = hcp_hvn.aws_hcp_vault_hvn.state
}

output "hvn_provider_account_id" {
  description = "The provider account ID of the HashiCorp Virtual Network (HVN) in AWS"
  value       = hcp_hvn.aws_hcp_vault_hvn.provider_account_id
}
