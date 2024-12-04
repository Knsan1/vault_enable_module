output "role_id" {
  description = "The Role ID for the configured AppRole"
  value       = vault_approle_auth_backend_role.aws_approle.role_id
  sensitive   = true
}

output "secret_id" {
  description = "The Secret ID associated with the configured AppRole"
  value       = vault_approle_auth_backend_role_secret_id.id.secret_id
  sensitive   = true
}
