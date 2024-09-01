output "dynamic_user_access_key" {
  description = "Dynamic User Access Key "
  value       = data.vault_aws_access_credentials.creds.access_key
}

output "dynamic_user_secret_key" {
  description = "Dynamic User Secret Access Key"
  value       =  data.vault_aws_access_credentials.creds.secret_key
}



