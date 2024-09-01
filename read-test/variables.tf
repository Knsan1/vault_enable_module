variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "vault_backend_path" {
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


variable "static_role_name" {
  description = "Static Role name"
  type        = string
}