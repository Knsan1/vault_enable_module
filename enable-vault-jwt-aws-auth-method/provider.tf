provider "vault" {
  address = "http://192.168.56.87:8200"
  token   = "xxxxxx"
  # Vault provider configuration
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  region     = "ap-southeast-1"
}