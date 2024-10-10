## Create VPC with 3 different subents on AWS with Sepcific Region
module "vpc" {
  source             = "git::https://github.com/Knsan1/vault_enable_module.git//modules/aws-vpc-with-gw"
  aws_region         = "ap-southeast-1"
  vpc_cidr_block     = "10.20.0.0/16"
  vpc_name           = "my-vault-vpc"
  public_cidr_block  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_cidr_block = ["10.20.3.0/24", "10.20.4.0/24"]
  db_cidr_block      = ["10.20.5.0/24", "10.20.6.0/24"]
}

## Create HVN network and run Vault cluster on HCP 
module "hvp_vault_cluster" {
  source         = "git::https://github.com/Knsan1/vault_enable_module.git//modules/hcp-vault"
  cidr_block     = "172.25.16.0/20"
  hvn_id         = "vault-hvn01"
  cloud_provider = "aws"
  region         = module.vpc.aws_region
  cluster_id     = "kns-vault-cluster01"
  tier           = "dev"
}

## Peering between HVN and VPC
module "hvn_peering" {
  source     = "git::https://github.com/Knsan1/vault_enable_module.git//modules/hvn-peering" # Adjust the path to your module
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

# Data source to retrieve AWS account ID
data "aws_caller_identity" "current" {}


## Create SG EC2 under Public Subnet
module "sg_ec2_instance" {
  source        = "git::https://github.com/Knsan1/vault_enable_module.git///modules/aws-simple-ec2"
  region        = module.vpc.aws_region   # Using the same region from the VPC module
  ami           = "ami-01811d4912b4ccb26" # SG Region Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "sg-ec2-keypair" # Create keypair manually first
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0] # Replace with your subnet ID
  instance_name = "sg-ec2-public-instance"
}

## Create SG EC2 under Private Subnet
module "sg_ec2_private_instance" {
  source        = "git::https://github.com/Knsan1/vault_enable_module.git///modules/aws-simple-ec2"
  region        = module.vpc.aws_region   # Using the same region from the VPC module
  ami           = "ami-01811d4912b4ccb26" # SG Region Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "sg-ec2-keypair" # Create keypair manually first
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_ids[0] # Replace with your subnet ID
  instance_name = "sg-ec2-private-instance"
}

## Create SG EC2 under DB Subnet
module "sg_ec2_db_instance" {
  source        = "git::https://github.com/Knsan1/vault_enable_module.git///modules/aws-simple-ec2"
  region        = module.vpc.aws_region   # Using the same region from the VPC module
  ami           = "ami-01811d4912b4ccb26" # SG Region Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "sg-ec2-keypair" # Create keypair manually first
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.db_subnet_ids[0] # Replace with your subnet ID
  instance_name = "sg-ec2-db-instance"
}

## Create Vault Admin IAM user for configure at AWS Vault Secret Engine
module "iam_user" {
  source = "git::https://github.com/Knsan1/vault_enable_module.git//modules/iam-user"

  user_name       = "vault-admin"
  policy_name     = "vault-admin-policy"
  aws_region      = module.vpc.aws_region # Pass the region to the module
  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachUserPolicy",
        "iam:CreateAccessKey",
        "iam:CreateUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:GetUser",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:AddUserToGroup",
        "iam:RemoveUserFromGroup"
      ],
      "Resource": [
        "arn:aws:iam::230788615808:user/*"
      ]
    }
  ]
}
EOT
}

## Eanble AWS Secret Engine on Vault Cluster
module "vault_enable_aws" {
  source     = "git::https://github.com/Knsan1/vault_enable_module.git//modules/vault-enable"
  depends_on = [module.iam_user]

  access_key_id     = module.iam_user.access_key_id
  secret_access_key = module.iam_user.secret_access_key
  vault_path        = "kns-aws-master"
  vault_token       = module.hvp_vault_cluster.vault_token_key
  vault_address     = module.hvp_vault_cluster.vault_public_endpoint
  min_ttl           = 120
  max_ttl           = 240
}


## Create EC2 Admin Dyanmic Role under AWS Secret Engine
module "aws_dynamic_role" {
  source             = "git::https://github.com/Knsan1/vault_enable_module.git//modules/vault-dynamic-role"
  depends_on         = [module.iam_user]
  vault_backend_path = module.vault_enable_aws.vault_backend_path
  role_name          = "ec2-admin-role"
  policy_document    = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOT
}