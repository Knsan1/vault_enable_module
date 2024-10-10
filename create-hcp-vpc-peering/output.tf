###SG Region EC2 Instance Output###
output "SG_Region_instance_id" {
  value = module.sg_ec2_instance.instance_id
}

output "SG_Region_instance_public_ip" {
  value = module.sg_ec2_instance.public_ip
}

output "SG_Region_instance_public_dns" {
  value = module.sg_ec2_instance.public_dns
}

output "SG_Region_instance_private_ip" {
  value = module.sg_ec2_instance.private_ip
}

output "SG_Region_instance_private_dns" {
  value = module.sg_ec2_instance.private_dns
}

###SG Region EC2 Private Instance Output###
output "SG_Region_Private_instance_id" {
  value = module.sg_ec2_private_instance.instance_id
}

output "SG_Region_Private_instance_public_ip" {
  value = module.sg_ec2_private_instance.public_ip
}

output "SG_Region_Private_instance_public_dns" {
  value = module.sg_ec2_private_instance.public_dns
}

output "SG_Region_Private_instance_private_ip" {
  value = module.sg_ec2_private_instance.private_ip
}

output "SG_Region_Private_instance_private_dns" {
  value = module.sg_ec2_private_instance.private_dns
}


###SG Region EC2 Private Instance Output###
output "SG_Region_DB_instance_id" {
  value = module.sg_ec2_db_instance.instance_id
}

output "SG_Region_DB_instance_public_ip" {
  value = module.sg_ec2_db_instance.public_ip
}

output "SG_Region_DB_instance_public_dns" {
  value = module.sg_ec2_db_instance.public_dns
}

output "SG_Region_DB_instance_private_ip" {
  value = module.sg_ec2_db_instance.private_ip
}

output "SG_Region_DB_instance_private_dns" {
  value = module.sg_ec2_db_instance.private_dns
}

###Vault Cluster Info Output###
output "Vault_Public_Endpoint" {
  description = "Vault Cluster Public Endpoint"
  value       = module.hvp_vault_cluster.vault_public_endpoint
}


output "Vault_Private_Endpoint" {
  description = "Vault Cluster Private Endpoint"
  value       = module.hvp_vault_cluster.vault_private_endpoint
}

# ###SG Region EC2  Private Instance Output###
# output "SG_Region_Private_instance_ips" {
#   value = module.sg_ec2_private_instance.aws_instance.this.private_ip
# }

# output "ec2_private_dns" {
#   value = module.sg_ec2_db_instance.aws_instance.this.private_dns
# }