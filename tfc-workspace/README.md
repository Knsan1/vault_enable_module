Here is a `README.md` file for your provided Terraform code:

```markdown
# Terraform Configuration for TFE Workspace with Vault and AWS Integration

This Terraform configuration sets up a [Terraform Cloud Workspace](https://www.terraform.io/cloud-docs/workspaces) and configures several environment variables to enable Vault and AWS provider authentication within the workspace.

## Resources

### 1. `tfe_workspace`
The `tfe_workspace` data source retrieves information about an existing Terraform Cloud workspace.

```hcl
data "tfe_workspace" "my_workspace" {
  name         = var.workspace_name
  organization = var.org_name
}
```

### 2. `tfe_variable`
These resources define environment variables required for authenticating and integrating the Terraform Cloud workspace with Vault and AWS.

| Resource | Key | Value | Description |
|----------|-----|-------|-------------|
| `tfe_variable.enable_vault_provider_auth` | `TFC_VAULT_PROVIDER_AUTH` | `"true"` | Enables the Vault provider authentication for the workspace. |
| `tfe_variable.tfc_vault_addr` | `TFC_VAULT_ADDR` | `var.vault_url` | The address of the Vault instance the workspace will access. |
| `tfe_variable.tfc_vault_role` | `TFC_VAULT_RUN_ROLE` | `var.run_role` | The Vault role that Terraform runs will use for authentication. |
| `tfe_variable.tfc_vault_namespace` | `TFC_VAULT_NAMESPACE` | `var.vault_namespace` | The Vault namespace that contains the AWS Secrets Engine. |
| `tfe_variable.enable_aws_provider_auth` | `TFC_VAULT_BACKED_AWS_AUTH` | `"true"` | Enables Vault Secrets Engine integration for AWS. |
| `tfe_variable.tfc_aws_mount_path` | `TFC_VAULT_BACKED_AWS_MOUNT_PATH` | `var.aws_mount_path` | The path where the AWS Secrets Engine is mounted in Vault. |
| `tfe_variable.tfc_aws_auth_type` | `TFC_VAULT_BACKED_AWS_AUTH_TYPE` | `var.aws_auth_type` | Specifies the authentication type used in the AWS Secrets Engine. |
| `tfe_variable.tfc_aws_run_vault_role` | `TFC_VAULT_BACKED_AWS_RUN_VAULT_ROLE` | `var.aws_secret_role` | The Vault role assumed via the AWS Secrets Engine. |
| `tfe_variable.aws_region` | `AWS_REGION` | `var.aws_region` | The default AWS region for the workspace. |

## Variables

The following input variables must be provided:

| Variable Name | Description |
|---------------|-------------|
| `workspace_name` | The name of the Terraform Cloud workspace. |
| `org_name` | The Terraform Cloud organization that owns the workspace. |
| `vault_url` | The address of the Vault instance. |
| `run_role` | The Vault role that runs will use to authenticate. |
| `vault_namespace` | The Vault namespace containing the AWS Secrets Engine. |
| `aws_mount_path` | The path where the AWS Secrets Engine is mounted in Vault. |
| `aws_auth_type` | The authentication type for the AWS Secrets Engine. |
| `aws_secret_role` | The Vault role for the AWS Secrets Engine. |
| `aws_region` | The default AWS region to be used in the workspace. |

## Usage

1. Ensure that the necessary variables are set either as environment variables or within your Terraform configuration.
2. Apply the configuration to your Terraform Cloud workspace to enable Vault and AWS authentication for your runs.

```bash
terraform init
terraform apply
```

## Links

- [Terraform TFE Provider Documentation](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
- [Vault AWS Secrets Engine Documentation](https://www.vaultproject.io/docs/secrets/aws)
- [Terraform Cloud Environment Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/environment-variables)
```

This `README.md` outlines the purpose of the code, lists the required input variables, explains the different environment variables being set in the Terraform Cloud workspace, and provides guidance on how to use the configuration.