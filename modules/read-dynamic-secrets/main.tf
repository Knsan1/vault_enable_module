# generally, these blocks would be in a different module
data "vault_aws_access_credentials" "creds" {
  backend = var.vault_backend_path
  role    = var.dynamic_role_name
}