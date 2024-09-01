variable "dynamic_role_name" {
  description = "Name of the IAM user"
  type        = string
}

variable "vault_backend_path" {
  description = "Path for the Vault AWS secret engine"
  type        = string
}
