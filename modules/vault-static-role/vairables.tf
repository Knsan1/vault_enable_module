# variable "aws_region" {
#   description = "AWS region"
#   type        = string
# }


# variable "vault_address" {
#   description = "Address of the Vault server"
#   type        = string
# }

# variable "vault_token" {
#   description = "Token to authenticate with Vault"
#   type        = string
# }

variable "static_iam_user" {
  description = "Name of the IAM user"
  type        = string
}

variable "vault_backend_path" {
  description = "Path for the Vault AWS secret engine"
  type        = string
}

variable "vault_role_name" {
  description = "Name of the Vault static role"
  type        = string
}

variable "vault_rotation_period" {
  description = "Rotation period for the Vault static role"
  type        = string
}
