variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
}

variable "cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
}

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
}

variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN and Vault cluster."
  type        = string
}

variable "tier" {
  description = "Tier of the HCP Vault cluster. Valid options for tiers."
  type        = string
}

variable "client_id" {
  description = "HCP Account Service Principle Client ID"
  type        = string
}

variable "client_secret" {
  description = "HCP Account Service Principle Client Key"
  type        = string
}

variable "vault_path" {
  description = "Vault Secret Engine Path"
  type        = string
}