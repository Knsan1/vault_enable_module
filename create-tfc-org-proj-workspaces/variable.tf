# variables.tf

# Organization Name
variable "organization_name" {
  description = "Terraform Cloud Organization Name"
  type        = string
  default     = "kns-testing-org" # Default value for organization name
}

# Project Name
variable "project_name" {
  description = "Project name in Terraform Cloud"
  type        = string
  default     = "mulitple-workspaces" # Default value for project name
}

# Workspace Names List
variable "workspace_names" {
  description = "List of workspace names to create in Terraform Cloud"
  type        = list(string)
  default = [
    "workspace01",
    "workspace02",
    "workspace03",
    "workspace04"
  ] # Default values for workspace names
}

# Tags List for Workspaces
variable "workspace_tags" {
  description = "Tags to apply to workspaces"
  type        = map(list(string)) # Maps workspace name to tag list
  default = {
    "workspace01" = ["test", "app"],
    "workspace02" = ["production", "critical"],
    "workspace03" = ["dev", "low-priority"],
    "workspace04" = ["new", "extra"],
  } # Default values for workspace tags
}
