###US Region VPC Related Output###
output "US_Region_vpc_id" {
  value = module.us_region_vpc.vpc_id
}

output "US_Region_public_subnet_ids" {
  value = module.us_region_vpc.public_subnet_ids
}

output "US_Region_private_subnet_ids" {
  value = module.us_region_vpc.private_subnet_ids
}

###SG Region VPC Related Output###
output "SG_Region_vpc_id" {
  value = module.sg_region_vpc.vpc_id
}

output "SG_Region_public_subnet_ids" {
  value = module.sg_region_vpc.public_subnet_ids
}

output "SG_Region_private_subnet_ids" {
  value = module.sg_region_vpc.private_subnet_ids
}

###US Region EC2 Instance utput###
output "US_Region_instance_id" {
  value = module.us_ec2_instance.instance_id
}

output "US_Region_instance_public_ip" {
  value = module.us_ec2_instance.public_ip
}

output "US_Region_instance_public_dns" {
  value = module.us_ec2_instance.public_dns
}


###SG Region EC2 Instance utput###
output "SG_Region_instance_id" {
  value = module.sg_ec2_instance.instance_id
}

output "SG_Region_instance_public_ip" {
  value = module.sg_ec2_instance.public_ip
}

output "SG_Region_instance_public_dns" {
  value = module.sg_ec2_instance.public_dns
}
