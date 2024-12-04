# Enable the AppRole authentication backend
resource "vault_auth_backend" "approle" {
  type = "approle"
}

# Define Vault policy for AppRole access
resource "vault_policy" "aws_approle_policy" {
  name = var.policy_name

  policy = var.policy_document
}

# Configure the AppRole with specific role and token policies
resource "vault_approle_auth_backend_role" "aws_approle" {
  backend        = vault_auth_backend.approle.path
  role_name      = var.role_name
  token_policies = [vault_policy.aws_approle_policy.name]
  token_ttl      = var.token_ttl
  token_max_ttl  = var.token_max_ttl
}

# Generate a Secret ID for the AppRole
resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.aws_approle.role_name
}
