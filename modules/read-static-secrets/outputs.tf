output "static_user_access_key" {
  description = "Static User Access Key "
  value       = data.vault_aws_static_access_credentials.creds.access_key
}

output "static_user_secret_key" {
  description = "Static User Secret Access Key"
  value       =  data.vault_aws_static_access_credentials.creds.secret_key
}



