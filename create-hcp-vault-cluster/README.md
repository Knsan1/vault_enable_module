---

# Terraform IAM and Vault Integration

This repository contains Terraform code to integrate AWS IAM user creation with HashiCorp Vault, including dynamic and static roles. It also provisions an HCP Vault Cluster and configures Vault for AWS credential management.

## Providers

### AWS and Vault Provider Configuration

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

### HCP and Vault Provider Configuration

```hcl
provider "hcp" {
  client_id     = var.client_id
  client_secret = var.client_secret
}

provider "vault" {
  address = module.hvp-vault-cluster.vault_public_endpoint
  token   = module.hvp-vault-cluster.vault_token_key
}
```

---

## Modules

### IAM User Module

This module creates an AWS IAM user and attaches policies to it.

```hcl
module "iam_user" {
  source = "../modules/iam-user"

  user_name       = var.user_name
  policy_name     = var.policy_name
  policy_document = var.policy_document
  aws_region      = var.aws_region
}
```

### Vault Enable Module

This module configures Vault to use the IAM user's credentials to manage secrets.

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

### HCP Vault Cluster Module

This module provisions and manages a HashiCorp Cloud Platform (HCP) Vault cluster. It sets up the Vault service in your cloud provider and configures the cluster.

```hcl
module "hvp-vault-cluster" {
  source = "../modules/hcp-vault"

  hvn_id         = var.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.region
  cluster_id     = var.cluster_id
  tier           = var.tier
}
```

---

## Description

### Vault Dynamic Role Module

This module creates a dynamic role in Vault that can be used to generate temporary AWS credentials.

### Read Static Secrets Module

This module reads static secrets from Vault and uses them to configure the AWS provider.

### HCP Vault Cluster Module

This module provisions and manages a HashiCorp Cloud Platform (HCP) Vault cluster. It configures the cluster with your chosen cloud provider, region, and service tier.

---

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
- `client_id`: HCP client ID for authenticating.
- `client_secret`: HCP client secret for authenticating.
- `hvn_id`: HCP Virtual Network ID.
- `cloud_provider`: The cloud provider to host the HCP Vault cluster.
- `region`: Region for the HCP Vault cluster.
- `cluster_id`: ID of the HCP Vault cluster.
- `tier`: Service tier for the HCP Vault cluster (e.g., `development`, `production`).

---

## Outputs

- `access_key_id`: The access key ID for the IAM user.
- `secret_access_key`: The secret access key for the IAM user.
- `vault_public_endpoint`: The public endpoint for accessing the HCP Vault cluster.
- `vault_token_key`: The Vault token for accessing the HCP Vault cluster.
- `vault_backend_path`: The path of the Vault backend where secrets are stored.

---

