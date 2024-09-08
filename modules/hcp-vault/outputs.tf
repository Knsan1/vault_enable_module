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
