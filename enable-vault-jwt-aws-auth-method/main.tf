###Enable AWS Auth on Vault(With AWS Role)
module "vault-aws-auth" {
  source = "git::https://github.com/Knsan1/vault_enable_module.git//modules/vault-aws-auth-backend"

  user_name             = "vault-auth-admin"
  policy_name           = "vault-auth-policy"
  actions               = ["ec2:DescribeInstances", "iam:GetInstanceProfile", "iam:GetUser", "iam:ListRoles", "iam:GetRole"]
  ec2_role_name         = "AWS_EC2_role"
  instance_profile_name = "vault-client-instance-profile"
  vault_policy_name     = "ec2-policy"
  vault_policy_document = <<EOT
# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}
# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}
path "ec2/" {
  capabilities = ["read","list"]
}
path "ec2/*" {
  capabilities = ["read","list"]
}
path "kns-aws-master-account/" {
  capabilities = ["read","list"]
}
path "kns-aws-master-account/*" {
  capabilities = ["read","list"]
}
EOT

  vault_role_name = "ec2-role"
  token_ttl       = 300
  token_max_ttl   = 600
}

###Enable JWT Auth on Vault(With Terraform Cloud)
module "enable_vault_jwt_auth_backend" {
  source             = "git::https://github.com/Knsan1/vault_enable_module.git//modules/vault-jwt-auth-backend-tfc" # Adjust the path if necessary
  description        = "JWT Auth Backend for my app"
  path               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
  policy_name        = "admin-policy"
  role_name          = "admin-role"
  bound_audiences    = ["vault.workload.identity"]
  bound_claims_type  = "glob"
  bound_claims = {
    sub = "organization:Hellocloud-kns:project:HCP Vault Project:workspace:*:run_phase:*"
  }
  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
  token_ttl  = 1200
}
