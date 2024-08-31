variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "user_name" {
  description = "The name of the IAM user"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  default     = "vault-user-policy"
}

variable "policy_name1" {
  description = "The name of the IAM policy"
  type        = string
  default     = "iam-user-policy"
}


variable "policy_document" {
  description = "The JSON-encoded policy document for the IAM policy"
  type        = string
}


variable "vault_path" {
  description = "The path for Vault AWS Secret Backend"
  type        = string
}

variable "vault_address" {
  description = "The address of the Vault server"
  type        = string
}

variable "vault_token" {
  description = "Token of Vault server"
  type        = string
}

variable "static_iam_user" {
  description = "Name of the IAM user"
  type        = string
}