## This Terraform code can use to create Organization, Project and Workspaces[Connect to Github Repo] in Terraform Cloud(TFC)
### Need to export TFC and Github Token as ENV variable for VCS WorkFlow
```
## Github account Token(classic) Full Repo Access
$ export TF_VAR_github_oauth_token="ghpxxxxxxxxxxxxxx"
## TFC Account Level Token
$ export TFE_TOKEN="xxxxxxxxxxxxxx"
## Check exproted token
$ export | grep -i token
```

---

# Terraform Cloud Workspace Setup

This Terraform configuration allows you to create a **Terraform Cloud organization**, **project**, and multiple **workspaces** linked to a GitHub repository. You can customize the setup by overriding the default variable values.

## Variables

### Organization Name

- **Variable**: `organization_name`
- **Default**: `"kns-vcs-org"`
- **Description**: Name of the Terraform Cloud organization (can be overwritten).

### Project Name

- **Variable**: `project_name`
- **Default**: `"kns-vcs-project"`
- **Description**: Name of the Terraform Cloud project (can be overwritten).

### GitHub Repository Name

- **Variable**: `repo_name`
- **Default**: `"Knsan1/co7-project"`
- **Description**: GitHub organization/repo (can be overwritten).

### Branch Name

- **Variable**: `branch_name`
- **Default**: `"master"`
- **Description**: GitHub branch to use (can be overwritten).

### Workspace Names and Directories

- **Variable**: `workspaces`
- **Default**: 
  ```hcl
  {
    "workspace01" = "enable-vault-kv-engine"
    "workspace02" = "tfc-workspace"
    "workspace03" = "vault-cluster"
  }
  ```
- **Description**: Map of workspaces with corresponding working directories (can be overwritten).

### Tags List for Workspaces

- **Variable**: `tag_names`
- **Default**: `["kns-hc", "test"]`
- **Description**: List of tags to apply to the workspaces (can be overwritten).

### GitHub OAuth Token

- **Variable**: `github_oauth_token`
- **Description**: GitHub Client Token (required and can be provided).

---

## Overriding Variables

To override any of the default values, you can create a `terraform.tfvars` file or provide the variables directly when running Terraform commands. 

### Example `terraform.tfvars`:

```hcl
organization_name = "my-custom-org"
project_name      = "my-custom-project"
repo_name         = "my-org/my-repo"
branch_name       = "main"
workspaces = {
  "workspace01" = "my-dir1"
  "workspace02" = "my-dir2"
}
tag_names = ["my-tag1", "my-tag2"]
github_oauth_token = "your-oauth-token"
```

---