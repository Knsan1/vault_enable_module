output "vault_dynamic_role_name" {
  description = "The name of the Vault dynamic role created."
  value       = vault_aws_secret_backend_role.role.name
}
