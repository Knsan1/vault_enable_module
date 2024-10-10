module "vpc" {
  source             = "../modules/aws-vpc-with-gw/"
  aws_region         = "ap-southeast-1"
  vpc_cidr_block     = "10.20.0.0/16"
  vpc_name           = "my-vault-vpc"
  public_cidr_block  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_cidr_block = ["10.20.3.0/24", "10.20.4.0/24"]
  db_cidr_block      = ["10.20.5.0/24", "10.20.6.0/24"]
}

module "hvp_vault_cluster" {
  source         = "../modules/hcp-vault"
  cidr_block     = "172.25.16.0/20"
  hvn_id         = "vault-hvn01"
  cloud_provider = "aws"
  region         = module.vpc.aws_region
  cluster_id     = "kns-vault-cluster01"
  tier           = "dev"
}

module "hvn_peering" {
  source     = "../modules/hvn-peering" # Adjust the path to your module
  depends_on = [module.hvp_vault_cluster, module.vpc]

  aws_region             = module.vpc.aws_region
  peer_account_id        = data.aws_caller_identity.current.account_id
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  db_subnet_ids          = module.vpc.db_subnet_ids
  private_route_table_id = module.vpc.private_route_table_id
  db_route_table_id      = module.vpc.db_route_table_id
  private_cidrs          = module.vpc.private_cidrs
  db_cidrs               = module.vpc.db_cidrs
  hvp_vault_cluster = {
    hvn_id         = module.hvp_vault_cluster.hvn_id
    hvn_self_link  = module.hvp_vault_cluster.hvn_self_link
    hvn_cidr_block = module.hvp_vault_cluster.hvn_cidr_block
  }
}

provider "aws" {
  region = module.vpc.aws_region
}

# Data source to retrieve AWS account ID
data "aws_caller_identity" "current" {}
