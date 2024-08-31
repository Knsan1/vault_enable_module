output "iam_user_name" {
  description = "The name of the IAM user"
  value       = module.iam_user.iam_user_name
}

output "vault_backend_path" {
  description = "The path of the Vault AWS Secret Backend"
  value       = module.vault_enable.vault_backend_path
}

output "static_iam_user" {
  description = "The name of the IAM user"
  value       = module.static_iam_user.iam_user_name
}


output "vault_static_role_name" {
  description = "The name of the Vault static role created."
  value       = module.iam_vault_static_role.vault_static_role_name
}

output "vault_dynamic_role_name" {
  description = "The name of the Vault dynamic role created."
  value       = module.dynamic_role.vault_dynamic_role_name
}


output "Read_Creds_static_role_path" {
  description = "The formatted path for the static role."
  value       = "${module.vault_enable.vault_backend_path}/static-creds/${module.iam_vault_static_role.vault_static_role_name}"
}

output "Read_Creds_dynamic_role_path" {
  description = "The formatted path for the dynamic role."
  value       = "${module.vault_enable.vault_backend_path}/creds/${module.dynamic_role.vault_dynamic_role_name}"
}

# output "Static_user_Key_read_path" {
#   description = "The name of the Vault static role created."
#   value       = module.vault_enable.vault_backend_path/module.iam_vault_static_role.vault_static_role_name/static-creds/module.iam_vault_static_role.vault_static_role_name
# }