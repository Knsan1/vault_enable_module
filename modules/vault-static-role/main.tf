resource "vault_aws_secret_backend_static_role" "static_role" {
  backend         = var.vault_backend_path
  name            = var.vault_role_name
  username        = var.static_iam_user
  rotation_period = var.vault_rotation_period
}