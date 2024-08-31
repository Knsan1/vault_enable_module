output "vault_backend_path" {
  description = "The path of the Vault AWS Secret Backend"
  value       = vault_aws_secret_backend.this.path
}
