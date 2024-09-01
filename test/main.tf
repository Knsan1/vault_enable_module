provider "aws" {
  region = var.aws_region
  # other AWS provider configuration
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
  # Vault provider configuration
}

module "iam_user" {
  source = "git::https://github.com/Knsan1/vault_enable_module.git//modules/iam-user"

  user_name       = var.user_name
  policy_name     = var.policy_name
  policy_document = var.policy_document
  aws_region      = var.aws_region # Pass the region to the module
}

module "vault_enable" {
  source     = "git::https://github.com/Knsan1/vault_enable_module.git//modules/vault-enable"
  depends_on = [module.iam_user]

  access_key_id     = module.iam_user.access_key_id
  secret_access_key = module.iam_user.secret_access_key
  vault_path        = var.vault_path
  vault_token       = var.vault_token
  vault_address     = var.vault_address
  min_ttl           = 120
  max_ttl           = 240
}

module "static_iam_user" {
  source = "git::https://github.com/Knsan1/vault_enable_module.git//modules/iam-user"

  user_name       = var.static_iam_user
  policy_name     = var.policy_name1
  policy_document = var.policy_document
  aws_region      = var.aws_region # Pass the region to the module
}

module "iam_vault_static_role" {
  source     = "git::https://github.com/Knsan1/vault_enable_module.git//modules/vault-static-role"
  depends_on = [module.iam_user]

  static_iam_user       = var.static_iam_user
  vault_backend_path    = module.vault_enable.vault_backend_path
  vault_role_name       = "test-static-role"
  vault_rotation_period = "600"
}


module "dynamic_role" {
  source             = "git::https://github.com/Knsan1/vault_enable_module.git//modules/vault-dynamic-role"
  depends_on         = [module.iam_user]
  vault_backend_path = module.vault_enable.vault_backend_path
  role_name          = "test-dynamic-role"
  policy_document    = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:GetUser",
      "Resource": "arn:aws:iam::730335624063:user/vault-token-terraform*"
    }
  ]
}
EOT
}
