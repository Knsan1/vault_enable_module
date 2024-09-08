output "Vault_Public_Endpoint" {
  description = "Vault Cluster Public Endpoint"
  value       = module.hvp-vault-cluster.vault_public_endpoint
}

output "Vault_Token_ID" {
  description = "Vault Admin TOken ID"
  value       = module.hvp-vault-cluster.vault_token_id
}

output "vault_backend_path" {
  description = "The path of the Vault AWS Secret Backend"
  value       = module.vault_enable.vault_backend_path
}

# output "Vault_Token_KEY" {
#   description = "Vault Admin TOken ID KEY"
#   value       = module.hvp-vault-cluster.vault_token_key
#   sensitive = true
# }