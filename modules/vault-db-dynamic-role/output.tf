output "database_secrets_mount_path" {
  description = "Path of the Vault database secrets engine."
  value       = vault_database_secrets_mount.db.path
}

output "readonly_rolename" {
  description = "Read Only Role Name"
  value       = vault_database_secret_backend_role.readonly.name
}

output "readwrite_rolename" {
  description = "Read Write Role Name"
  value       = vault_database_secret_backend_role.readwrite.name
}