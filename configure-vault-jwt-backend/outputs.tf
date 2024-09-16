output "vault_jwt_auth_role_name" {
  description = "JWT Rolename"
  value       = module.enable_vault_jwt_auth_backend.jwt_auth_backend_path
}

output "vault_jwt_openid_claim" {
  description = "Sub Infomration for JWT"
  value       = module.enable_vault_jwt_auth_backend.openid_claim
}
