# ###SG Region EC2 Instance Output###
# output "SG_Region_instance_id" {
#   value = module.sg_ec2_instance.instance_id
# }

# output "SG_Region_instance_public_ip" {
#   value = module.sg_ec2_instance.public_ip
# }

# output "SG_Region_instance_public_dns" {
#   value = module.sg_ec2_instance.public_dns
# }

# output "SG_Region_instance_private_ip" {
#   value = module.sg_ec2_instance.private_ip
# }

# output "SG_Region_instance_private_dns" {
#   value = module.sg_ec2_instance.private_dns
# }

# ###SG Region EC2 Private Instance Output###
# output "SG_Region_Private_instance_id" {
#   value = module.sg_ec2_private_instance.instance_id
# }

# output "SG_Region_Private_instance_public_ip" {
#   value = module.sg_ec2_private_instance.public_ip
# }

# output "SG_Region_Private_instance_public_dns" {
#   value = module.sg_ec2_private_instance.public_dns
# }

# output "SG_Region_Private_instance_private_ip" {
#   value = module.sg_ec2_private_instance.private_ip
# }

# output "SG_Region_Private_instance_private_dns" {
#   value = module.sg_ec2_private_instance.private_dns
# }


# ###SG Region EC2 Private Instance Output###
# output "SG_Region_DB_instance_id" {
#   value = module.sg_ec2_db_instance.instance_id
# }

# output "SG_Region_DB_instance_public_ip" {
#   value = module.sg_ec2_db_instance.public_ip
# }

# output "SG_Region_DB_instance_public_dns" {
#   value = module.sg_ec2_db_instance.public_dns
# }

# output "SG_Region_DB_instance_private_ip" {
#   value = module.sg_ec2_db_instance.private_ip
# }

# output "SG_Region_DB_instance_private_dns" {
#   value = module.sg_ec2_db_instance.private_dns
# }

###Vault Cluster Info Output###
output "Vault_Public_Endpoint" {
  description = "Vault Cluster Public Endpoint"
  value       = module.hvp_vault_cluster.vault_public_endpoint
}

output "Vault_Private_Endpoint" {
  description = "Vault Cluster Private Endpoint"
  value       = module.hvp_vault_cluster.vault_private_endpoint
}

## Output for Vault Backend path and role name
output "iam_user_name" {
  description = "The name of the IAM user"
  value       = module.iam_user.iam_user_name
}

output "vault_backend_path" {
  description = "The path of the Vault AWS Secret Backend"
  value       = module.vault_enable_aws.vault_backend_path
}

output "vault_dynamic_role_name" {
  description = "The name of the Vault dynamic role created."
  value       = module.aws_dynamic_role.vault_dynamic_role_name
}

output "Read_Creds_dynamic_role_path" {
  description = "The formatted path for the dynamic role."
  value       = "${module.vault_enable_aws.vault_backend_path}/creds/${module.aws_dynamic_role.vault_dynamic_role_name}"
}

# output "public_subnet_ids" {
#   value = module.aws_ec2_rds_instances.public_subnet_ids
# }

# output "private_subnet_ids" {
#   value = module.aws_ec2_rds_instances.private_subnet_ids
# }

###Output from EC2 and RDS###
output "rds_hostname" {
  description = "RDS instance hostname"
  value       = module.aws_ec2_rds_instances.rds_hostname
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.aws_ec2_rds_instances.rds_port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = module.aws_ec2_rds_instances.rds_username
}

output "endpoints" {
  value = module.aws_ec2_rds_instances.endpoints
}

output "private_key" {
  description = "TLS private key PEM"
  value       = module.aws_ec2_rds_instances.private_key
}

## DB Secret Engine related output
# output "database_secrets_mount_path" {
#   description = "Path of the Vault database secrets engine."
#   value       = module.vault_db_secrets.database_secrets_mount_path
# }

# output "db_readwrite_role_name" {
#   description = "Name of the readwrite role."
#   value       = module.vault_db_secrets.readwrite_role_name
# }

# output "db_readonly_role_name" {
#   description = "Name of the readonly role."
#   value       = module.vault_db_secrets.readonly_role_name
# }