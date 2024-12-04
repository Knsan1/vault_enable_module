variable "policy_name" {
  description = "Name of the Vault policy for AppRole access"
  type        = string
  default     = "aws-approle-policy"
}

variable "policy_document" {
  description = "Policy document defining Vault access capabilities"
  type        = string
  default     = <<EOT
path "aws-master-account/*" {
  capabilities = ["read"]
}
path "db/*" {
  capabilities = ["read"]
}
EOT
}

variable "role_name" {
  description = "The AppRole name for AWS authentication"
  type        = string
  default     = "aws-approle"
}

variable "token_ttl" {
  description = "Time to live for tokens issued for this AppRole"
  type        = number
  default     = 300
}

variable "token_max_ttl" {
  description = "Maximum time to live for tokens issued for this AppRole"
  type        = number
  default     = 600
}
