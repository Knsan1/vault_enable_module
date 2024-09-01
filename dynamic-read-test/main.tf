provider "aws" {
  region     = var.aws_region
  access_key = module.read_dynamic_key.dynamic_user_access_key
  secret_key = module.read_dynamic_key.dynamic_user_secret_key
  # other AWS provider configuration
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
  # Vault provider configuration
}


module "read_dynamic_key" {
  source = "../modules/read-dynamic-secrets"

  vault_backend_path = var.vault_backend_path
  dynamic_role_name  = var.dynamic_role_name
}

data "aws_caller_identity" "dynamic_iam_user" {
  # provider = aws.sts-master-programmatic-admin # not required by default, unless we define # alias = "sts-master-programmatic-admin" in versions.tf
}
