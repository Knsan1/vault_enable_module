# AppRole Authentication Module for Vault

This module enables and configures an AppRole authentication backend on HashiCorp Vault, allowing you to define policies and generate Role IDs and Secret IDs securely.

## Features

- Enables AppRole authentication backend in Vault
- Creates Vault policies to define access permissions
- Configures AppRoles with custom TTL settings
- Outputs sensitive Role ID and Secret ID for integration with applications

## Usage

```hcl
module "approle_auth_backend" {
  source           = "./path/to/approle-auth-backend"
  policy_name      = "custom-aws-approle-policy"
  policy_document  = <<EOT
path "aws-master-account/*" {
  capabilities = ["read"]
}
path "db/*" {
  capabilities = ["read"]
}
EOT
  role_name        = "custom-aws-approle"
  token_ttl        = 600
  token_max_ttl    = 1200
}
```

## Inputs

| Name             | Description                                | Type     | Default               |
|------------------|--------------------------------------------|----------|-----------------------|
| `policy_name`    | Name of the Vault policy                   | `string` | `"aws-approle-policy"`|
| `policy_document`| Policy defining access permissions         | `string` | Default access paths  |
| `role_name`      | The name for the AppRole                   | `string` | `"aws-approle"`       |
| `token_ttl`      | Token TTL for issued tokens                | `number` | `300`                 |
| `token_max_ttl`  | Max TTL for issued tokens                  | `number` | `600`                 |

## Outputs

| Name          | Description                       |
|---------------|-----------------------------------|
| `Role_ID`     | Role ID for AppRole authentication (sensitive) |
| `Secret_ID`   | Secret ID for AppRole authentication (sensitive) |

**Note**: The `Role_ID` and `Secret_ID` outputs are sensitive and should be handled securely.
``` 

This structure allows you to configure, reuse, and extend the AppRole authentication setup as needed, while securely managing access credentials.