variable "description" {
  type        = string
  description = "Description for the JWT auth backend"
  default     = "Demonstration of the Terraform JWT auth backend"
}

variable "path" {
  type        = string
  description = "The path where the JWT auth backend will be mounted"
  default     = "jwt"
}

variable "oidc_discovery_url" {
  type        = string
  description = "OIDC Discovery URL"
  default     = "https://app.terraform.io"
}

variable "bound_issuer" {
  type        = string
  description = "Issuer for the JWT"
  default     = "https://app.terraform.io"
}

variable "policy_name" {
  type        = string
  description = "The name of the Vault policy"
  default     = "admin-policy"
}

variable "policy" {
  type        = string
  description = "The Vault policy"
  default     = <<EOT
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}
path "sys/auth" {
  capabilities = ["read"]
}
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/mounts" {
  capabilities = ["read"]
}
path "aws-master-account/" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "aws-master-account/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/mounts/example" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
path "example/*" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
EOT
}

variable "role_name" {
  type        = string
  description = "The name of the role"
  default     = "admin-role"
}

variable "bound_audiences" {
  type        = list(string)
  description = "A list of audiences for the JWT role"
  default     = ["vault.workload.identity"]
}

variable "bound_claims_type" {
  type        = string
  description = "Type of bound claims"
  default     = "glob"
}

variable "bound_claims" {
  type        = map(string)
  description = "Bound claims for the JWT role"
  default = {
    sub = "organization:Hellocloud-kns:project:HCP Vault Project:workspace:*:run_phase:*"
  }
}

variable "user_claim" {
  type        = string
  description = "Claim that maps to the user"
  default     = "terraform_full_workspace"
}

variable "role_type" {
  type        = string
  description = "Type of the JWT role"
  default     = "jwt"
}

variable "token_ttl" {
  type        = number
  description = "TTL for the token"
  default     = 1200
}
