# generally, these blocks would be in a different module
data "vault_aws_static_access_credentials" "creds" {
  backend = var.vault_backend_path
  name    = var.static_role_name
}