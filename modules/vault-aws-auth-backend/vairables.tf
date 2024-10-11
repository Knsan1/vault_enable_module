variable "user_name" {
  description = "Name of the IAM user"
  type        = string
}

variable "user_path" {
  description = "Path for the IAM user"
  type        = string
  default     = "/"
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "actions" {
  description = "Actions for the IAM policy"
  type        = list(string)
}

variable "ec2_role_name" {
  description = "Name of the EC2 IAM role"
  type        = string
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
}

variable "vault_policy_name" {
  description = "Name of the Vault policy"
  type        = string
}

variable "vault_policy_document" {
  description = "Vault policy document"
  type        = string
}

variable "vault_role_name" {
  description = "Name of the Vault AWS auth role"
  type        = string
}

variable "token_ttl" {
  description = "TTL for Vault tokens"
  type        = number
  default     = 300
}

variable "token_max_ttl" {
  description = "Maximum TTL for Vault tokens"
  type        = number
  default     = 600
}
