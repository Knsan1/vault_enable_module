# provider "vault" {
#   alias   = "vrd1"
#   address = var.vault_address
#   token   = var.vault_token
# }

resource "vault_aws_secret_backend" "this" {
  access_key = var.access_key_id
  secret_key = var.secret_access_key
  path       = var.vault_path
  default_lease_ttl_seconds = var.min_ttl
  max_lease_ttl_seconds     = var.max_ttl
}
