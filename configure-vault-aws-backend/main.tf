provider "vault" {
  address = "http://192.168.56.87:8200"
  token   = "xxxxxxxx"
  # Vault provider configuration
}

# generally, these blocks would be in a different module
data "vault_aws_access_credentials" "creds" {
  backend = "kns-aws-master-account"
  role    = "master-admin-vault-role"
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  region     = "ap-southeast-1"
}

module "vault-aws-auth" {
  source = "../modules/vault-aws-auth-backend"

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
