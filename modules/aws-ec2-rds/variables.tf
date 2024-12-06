variable "vpc_id" {
  description = "VPC ID for using EC2 and RDS ."
  type        = string
  # default     = "replace your VPC ID"
}


variable "vault_private_endpoint_url" {
  description = "Vault Private Endpoint URL."
  type        = string
  # default     = "replace your Vault Private Address"
}


variable "Role_ID" {
  description = "Vault Role ID for Approle Access."
  type        = string
  # default     = "replace your Vault Private Address"
}

variable "Secret_ID" {
  description = "Vault Secret ID for Approle Access."
  type        = string
  # default     = "replace your Vault Private Address"
}

variable "hvn_cidr" {
  description = "Network CIDR for Vault Cluster."
  type        = string
  # default     = "replace your Vault Private Address"
}

variable "instance_profile_id" {
  description = "Instance Provile for EC2"
  type        = string
  # default     = "replace your Vault Private Address"
}

# variable "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   type        = list(string)
# }

# variable "private_subnet_ids" {
#   description = "List of private subnet IDs"
#   type        = list(string)
# }

variable "public_subnet_ids" {
  description = "Map of public subnet IDs"
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "Map of private subnet IDs"
  type        = map(string)
}
