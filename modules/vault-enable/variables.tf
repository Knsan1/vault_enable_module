variable "access_key_id" {
  description = "The access key ID of the IAM user"
  type        = string
}

variable "secret_access_key" {
  description = "The secret access key of the IAM user"
  type        = string
}

# variable "vault_provider" {
#   description = "The Vault provider to use"
#   type        = string
# }

variable "vault_path" {
  description = "The path for Vault AWS Secret Backend"
  type        = string
  default     = "master-admin"
}

variable "min_ttl" {
  description = "Maximum time-to-live (TTL) in seconds"
  type        = number
  default     = 3600  # Default to 1 hour if not provided
}

variable "max_ttl" {
  description = "Maximum time-to-live (TTL) in seconds"
  type        = number
  default     = 3600  # Default to 1 hour if not provided
}

# variable "vault_address" {
#   description = "The address of the Vault server"
#   type        = string
# }

# variable "vault_token" {
#   description = "Token of Vault server"
#   type        = string
# }