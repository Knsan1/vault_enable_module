provider "hcp" {
  client_id     = var.client_id
  client_secret = var.client_secret
}

provider "vault" {
  address = module.hvp-vault-cluster.vault_public_endpoint
  token   = module.hvp-vault-cluster.vault_token_key
  # Vault provider configuration
}

module "hvp-vault-cluster" {
  source = "../modules/hcp-vault"

  hvn_id         = var.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.region

  cluster_id = var.cluster_id
  tier       = var.tier
}


module "vault_enable" {
  source     = "../modules/vault-enable"
  depends_on = [module.hvp-vault-cluster]

  access_key_id     = "KNS1234567"
  secret_access_key = "PWS1234567"
  vault_path        = var.vault_path
  vault_address     = module.hvp-vault-cluster.vault_public_endpoint
  vault_token       = module.hvp-vault-cluster.vault_token_key
  min_ttl           = 120
  max_ttl           = 240
}