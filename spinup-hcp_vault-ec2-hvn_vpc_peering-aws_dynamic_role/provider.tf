## Provider infromation
provider "aws" {
  region = module.vpc.aws_region
}

provider "vault" {
  address = module.hvp_vault_cluster.vault_public_endpoint
  token   = module.hvp_vault_cluster.vault_token_key
  # Vault provider configuration
}