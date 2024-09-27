# Organization Name
variable "organization_name" {
  description = "Name of the Terraform Cloud organization"
  type        = string
  default     = "kns-vcs-org"
}

# Project Name
variable "project_name" {
  description = "Name of the Terraform Cloud project"
  type        = string
  default     = "kns-vcs-project"
}

# GitHub Repository Name
variable "repo_name" {
  description = "GitHub organization/repo"
  type        = string
  default     = "Knsan1/co7-project"
}

# Branch Name
variable "branch_name" {
  description = "GitHub branch to use"
  type        = string
  default     = "master"
}

# Workspace Names and Directories
variable "workspaces" {
  description = "Map of workspaces with corresponding working directories"
  type        = map(string)
  default = {
    "workspace01" = "enable-vault-kv-engine"
    "workspace02" = "tfc-workspace"
    "workspace03" = "vault-cluster"
  }
}

variable "github_oauth_token" {
  description = "GitHub Client Token"
  type        = string
}
### Need to export TFC and Github Token as ENV variable
## Github account Token(classic) Full Repo Access
# $ export TF_VAR_github_oauth_token="ghpxxxxxxxxxxxxxx"
## TFC Account Level Token
# $ export TFE_TOKEN="xxxxxxxxxxxxxx"