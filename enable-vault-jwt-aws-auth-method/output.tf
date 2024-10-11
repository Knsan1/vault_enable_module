# Outputs for AWS Auth module
output "iam_user_name" {
  description = "The name of the IAM user created for Vault AWS authentication."
  value       = module.vault-aws-auth.iam_user_name
}

output "ec2_role_name" {
  description = "The name of the IAM role created for EC2 instances to assume for Vault AWS authentication."
  value       = module.vault-aws-auth.ec2_role_name
}

output "vault_role_name" {
  description = "The name of the Vault AWS authentication backend role configured with the IAM role."
  value       = module.vault-aws-auth.vault_role_name
}

# Outputs for JWT Auth module
output "jwt_auth_backend_path" {
  description = "The path in Vault where the JWT authentication backend is enabled."
  value       = module.enable_vault_jwt_auth_backend.jwt_auth_backend_path
}

output "jwt_role_name" {
  description = "The name of the role created for the Vault JWT authentication backend."
  value       = module.enable_vault_jwt_auth_backend.role_name
}

output "jwt_openid_claim" {
  description = "The OpenID claim used by the JWT authentication backend to validate the incoming token."
  value       = module.enable_vault_jwt_auth_backend.openid_claim
}
