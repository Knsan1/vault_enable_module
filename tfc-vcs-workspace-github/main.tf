provider "tfe" {
  hostname = "app.terraform.io" # or your HCP Terraform hostname
}

# Create Terraform Cloud Organization
resource "tfe_organization" "my_org" {
  name  = var.organization_name # Replace with your desired organization name
  email = "admin@company.com"   # Replace with your admin email
}

# Create Terraform Cloud Project under the organization
resource "tfe_project" "my_project" {
  name         = var.project_name             # Replace with your desired project name
  organization = tfe_organization.my_org.name # Link to the organization
}

resource "tfe_oauth_client" "github" {
  organization     = tfe_organization.my_org.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_oauth_token
  service_provider = "github"
}

####Manual Connect between TFC and Github
# Create workspaces with variables
resource "tfe_workspace" "workspace" {
  for_each               = var.workspaces
  name                   = each.key
  organization           = tfe_organization.my_org.name
  project_id             = tfe_project.my_project.id
  description            = "Workspace for handling ${each.key}"
  allow_destroy_plan     = true
  auto_apply_run_trigger = true
  file_triggers_enabled  = true
  working_directory      = each.value
  tag_names              = var.tag_names

  vcs_repo {
    identifier     = var.repo_name                          # Use the variable for GitHub repo
    branch         = var.branch_name                        # Use the variable for branch
    oauth_token_id = tfe_oauth_client.github.oauth_token_id # OAuth token from tfe_oauth_client
  }
}

