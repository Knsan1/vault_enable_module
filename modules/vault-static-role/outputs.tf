output "vault_static_role_name" {
  description = "The name of the Vault static role created."
  value       = vault_aws_secret_backend_static_role.static_role.name
}




