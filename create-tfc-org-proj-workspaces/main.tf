# main.tf

provider "tfe" {
  hostname = "app.terraform.io"
}

# Create Terraform Cloud Organization
resource "tfe_organization" "organization" {
  name  = var.organization_name # Use the variable for organization name
  email = "test@gmail.com"
}

# Create Terraform Cloud Project under the organization
resource "tfe_project" "project" {
  organization = tfe_organization.organization.name # Link to organization
  name         = var.project_name                   # Use the variable for project name
}

# Create multiple workspaces under the project using a loop
resource "tfe_workspace" "workspaces" {
  for_each     = toset(var.workspace_names)         # Iterate over the list of workspace names
  name         = each.key                           # Assign each workspace name from the list
  organization = tfe_organization.organization.name # Link to the organization

  # Assign the workspace to the project
  project_id = tfe_project.project.id

  # Assign the tags specific to the workspace
  tag_names = lookup(var.workspace_tags, each.key, [])
}
