Here is the README file for the `vault-aws-auth-backend` module:

---

# Vault AWS Auth Backend Module

This Terraform module manages the configuration of an AWS IAM user, EC2 IAM role, Vault AWS authentication backend, and the integration between AWS and Vault. It sets up an IAM user with access keys, configures the AWS auth method in Vault, and creates the necessary Vault policies and roles for managing EC2 instance authentication.

## Module Overview

The `vault-aws-auth-backend` module performs the following tasks:
1. **IAM User Creation**: Creates an AWS IAM user that will be used for Vault's AWS authentication.
2. **IAM Access Key**: Generates access keys for the IAM user to enable programmatic access.
3. **IAM Policy**: Attaches a custom IAM policy to the user that grants permissions required by Vault for AWS authentication.
4. **EC2 Role Creation**: Creates an IAM role for EC2 instances to assume.
5. **Instance Profile**: Creates an instance profile to be attached to EC2 instances for integration with Vault.
6. **Vault Auth Backend Configuration**: Configures the AWS authentication backend in Vault and links it with the created IAM user.
7. **Vault Policy and Role**: Sets up Vault policies and creates a role for EC2 instances to authenticate with Vault.

## Usage

To use this module, include it in your Terraform configuration and provide the necessary inputs.

### Example

```hcl
module "vault_aws_auth_backend" {
  source              = "git::https://github.com/your-repo/vault-aws-auth-backend.git"
  
  aws_region          = "us-east-1"                 # AWS region for creating resources
  user_name           = "vault-auth-admin"          # Name of the IAM user for Vault auth
  role_name           = "AWS_EC2_role"              # Name of the EC2 role for AWS auth backend
  actions             = ["ec2:DescribeInstances",    # List of AWS actions allowed by the policy
                         "iam:GetInstanceProfile",
                         "iam:GetUser",
                         "iam:ListRoles",
                         "iam:GetRole"]

  vault_backend_path  = "auth/aws"                  # Path where Vault AWS auth is enabled
  token_ttl           = 300                         # Token TTL for Vault role
  token_max_ttl       = 600                         # Max Token TTL for Vault role
}

output "aws_auth_role_name" {
  value = module.vault_aws_auth_backend.aws_auth_role_name
}
```

### Inputs

| Name                          | Description                                                                                      | Type   | Default           | Required |
|-------------------------------|--------------------------------------------------------------------------------------------------|--------|-------------------|----------|
| `user_name`                    | Name of the AWS IAM user to create.                                                              | string | `""`              | yes      |
| `iam_policy_name`              | Name of the IAM user policy to be attached.                                                      | string | `""`              | yes      |
| `vault_policy_name`            | Name of the Vault policy to create.                                                              | string | `""`              | yes      |
| `role_name`                    | Name of the Vault role to create.                                                                | string | `""`              | yes      |
| `aws_region`                   | AWS region where resources will be created.                                                      | string | `""`              | yes      |
| `policy_document`              | IAM policy document JSON defining permissions for the IAM user.                                  | string | `""`              | yes      |
| `assume_role_policy_document`  | IAM policy document JSON defining the assume role policy for the EC2 role.                       | string | `""`              | yes      |
| `vault_backend_path`           | Path where the AWS auth backend is enabled in Vault.                                             | string | `"auth/aws"`      | no       |

### Outputs

| Name                        | Description                                      |
|-----------------------------|--------------------------------------------------|
| `aws_auth_role_name`         | The name of the Vault AWS auth backend role.     |

## How it Works

1. The module creates an IAM user with a specified policy granting permissions needed by Vault to authenticate AWS resources.
2. Access keys are generated for this user and stored in Vault for use by the Vault AWS auth backend.
3. The module creates an IAM role and instance profile, which are assumed by EC2 instances to authenticate with Vault.
4. Vault policies are created to manage the permissions that authenticated EC2 instances will have when accessing Vault.

## Requirements

- AWS provider
- Vault provider

## Providers

- AWS
- Vault

## Resources

- AWS IAM User
- AWS IAM Policy
- AWS IAM Role
- AWS IAM Instance Profile
- Vault Auth Backend
- Vault AWS Auth Backend Client
- Vault Policy
- Vault AWS Auth Backend Role

