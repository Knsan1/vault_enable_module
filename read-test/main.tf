provider "aws" {
  region     = var.aws_region
  access_key = module.read_static_key.static_user_access_key
  secret_key = module.read_static_key.static_user_secret_key
  # other AWS provider configuration
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
  # Vault provider configuration
}


module "read_static_key" {
  source = "../modules/read-static-secrets"

  vault_backend_path = var.vault_backend_path
  static_role_name   = var.static_role_name
}

data "aws_caller_identity" "static_iam_user" {
  # provider = aws.sts-master-programmatic-admin # not required by default, unless we define # alias = "sts-master-programmatic-admin" in versions.tf
}
