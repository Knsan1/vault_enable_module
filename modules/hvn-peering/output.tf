# hvn_vpc_peering_module/outputs.tf

output "peering_id" {
  value = hcp_aws_network_peering.hvn_to_vpc.provider_peering_id
}
