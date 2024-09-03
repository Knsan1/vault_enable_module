# Terraform IAM and Vault Integration

## AWS and Vault Provider Configuration

```hcl
provider "aws" {
  region = var.aws_region
  # other AWS provider configuration
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
  # Vault provider configuration
}
```

## IAM User Creation

```hcl
module "iam_user" {
  source = "../modules/iam-user"

  user_name       = var.user_name
  policy_name     = var.policy_name
  policy_document = var.policy_document
  aws_region      = var.aws_region
}
```

## Vault Enable Module Configuration

```hcl
module "vault_enable" {
  source     = "../modules/vault-enable"
  depends_on = [module.iam_user]

  access_key_id     = module.iam_user.access_key_id
  secret_access_key = module.iam_user.secret_access_key
  vault_path        = var.vault_path
  vault_token       = var.vault_token
  vault_address     = var.vault_address
  min_ttl           = 120
  max_ttl           = 240
}
```

## Static IAM User Creation

```hcl
module "static_iam_user" {
  source = "../modules/iam-user"

  user_name       = var.static_iam_user
  policy_name     = var.policy_name1
  policy_document = var.policy_document
  aws_region      = var.aws_region
}
```

## Vault Static Role Configuration

```hcl
module "iam_vault_static_role" {
  source     = "../modules/vault-static-role"
  depends_on = [module.iam_user]

  static_iam_user       = var.static_iam_user
  vault_backend_path    = module.vault_enable.vault_backend_path
  vault_role_name       = "dev-static-role"
  vault_rotation_period = "600"
}
```

## Vault Dynamic Role Configuration

```hcl
module "dynamic_role" {
  source             = "../modules/vault-dynamic-role"
  depends_on         = [module.iam_user]
  vault_backend_path = module.vault_enable.vault_backend_path
  role_name          = "dev-dynamic-role"
  policy_document    = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOT
}
```

## Reading Static Secrets from Vault

```hcl
module "read_static_key" {
  source = "../modules/read-static-secrets"

  vault_backend_path = var.vault_backend_path
  static_role_name   = var.static_role_name
}

provider "aws" {
  region     = var.aws_region
  access_key = module.read_static_key.static_user_access_key
  secret_key = module.read_static_key.static_user_secret_key
}
```

## Modules

### IAM User Module

This module creates an IAM user with a specified policy. It also outputs the access key and secret key for the user, which can be used by other modules.

### Vault Enable Module

This module configures the Vault backend with the necessary IAM credentials, enabling it to manage AWS roles and policies.

### Static IAM User Module

This module creates a static IAM user for use in Vault static roles.

### Vault Static Role Module

This module creates a static role in Vault associated with the IAM user created by the `static_iam_user` module.

### Vault Dynamic Role Module

This module creates a dynamic role in Vault that can be used to generate temporary AWS credentials.

### Read Static Secrets Module

This module reads static secrets from Vault and uses them to configure the AWS provider.

## Variables

- `aws_region`: AWS region to create the resources.
- `vault_address`: Address of the Vault server.
- `vault_token`: Authentication token for Vault.
- `vault_path`: Path in Vault for storing secrets.
- `user_name`: Name of the IAM user.
- `policy_name`: Name of the IAM policy.
- `policy_document`: JSON document defining the IAM policy.
- `static_iam_user`: Name of the static IAM user for Vault static roles.
- `static_role_name`: Name of the Vault static role.

## Outputs

- `access_key_id`: The access key ID for the IAM user.
- `secret_access_key`: The secret access key for the IAM user.

## Prerequisites

- Terraform v1.0 or later
- AWS account
- HashiCorp Vault instance

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Authors

- [KNS](https://github.com/Knsan1)
