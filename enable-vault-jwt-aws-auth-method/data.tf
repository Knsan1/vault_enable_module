# generally, these blocks would be in a different module
data "vault_aws_access_credentials" "creds" {
  backend = "kns-aws-master-account"
  role    = "master-admin-vault-role"
}