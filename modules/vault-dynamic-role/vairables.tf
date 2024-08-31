variable "vault_backend_path" {
  description = "The path of the Vault AWS secret backend."
  type        = string
}

variable "role_name" {
  description = "The name of the Vault role."
  type        = string
}

variable "policy_document" {
  description = "The policy document for the role."
  type        = string
}
