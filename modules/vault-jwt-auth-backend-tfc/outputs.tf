output "jwt_auth_backend_path" {
  value = vault_jwt_auth_backend.this.path
}

output "role_name" {
  description = "Vault backend JWT role name"
  value       = vault_jwt_auth_backend_role.admin_role.role_name
}

output "openid_claim" {
  description = "Vault backend JWT role subject to validate incoming token"
  value       = vault_jwt_auth_backend_role.admin_role.bound_claims
}
