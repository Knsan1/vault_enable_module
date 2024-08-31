resource "vault_aws_secret_backend_role" "role" {
  backend         = var.vault_backend_path
  name            = var.role_name
  credential_type = "iam_user"

  policy_document = var.policy_document
}
