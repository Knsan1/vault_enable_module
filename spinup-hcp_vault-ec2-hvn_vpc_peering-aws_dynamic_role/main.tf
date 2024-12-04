## Create VPC with 3 different subents on AWS with Sepcific Region
module "vpc" {
  source             = "git::https://github.com/Knsan1/vault_enable_module.git//modules/aws-vpc-with-gw"
  aws_region         = "ap-southeast-1"
  vpc_cidr_block     = "10.20.0.0/16"
  vpc_name           = "my-vault-vpc"
  public_cidr_block  = ["10.20.1.0/24", "10.20.4.0/24", "10.20.7.0/24"]
  private_cidr_block = ["10.20.2.0/24", "10.20.5.0/24", "10.20.8.0/24"]
  db_cidr_block      = ["10.20.3.0/24", "10.20.6.0/24", "10.20.9.0/24"]
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

###Enable AWS Auth on Vault(With AWS Role)
module "vault-aws-auth" {
  source = "../modules/vault-aws-auth-backend"

  user_name             = "vault-auth-admin"
  policy_name           = "vault-auth-policy"
  actions               = ["ec2:DescribeInstances", "iam:GetInstanceProfile", "iam:GetUser", "iam:ListRoles", "iam:GetRole"]
  ec2_role_name         = "AWS_EC2_role"
  instance_profile_name = "vault-client-instance-profile"
  vault_policy_name     = "ec2-policy"
  vault_policy_document = <<EOT
# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}
# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}
path "ec2/" {
  capabilities = ["read","list"]
}
path "ec2/*" {
  capabilities = ["read","list"]
}
path "db/" {
  capabilities = ["read","list"]
}
path "db/*" {
  capabilities = ["read","list"]
}
path "kns-aws-master-account/" {
  capabilities = ["read","list"]
}
path "kns-aws-master-account/*" {
  capabilities = ["read","list"]
}
EOT

  vault_role_name = "ec2-role"
  token_ttl       = 300
  token_max_ttl   = 600
}

###Enable JWT Auth on Vault(With Terraform Cloud)
module "enable_vault_jwt_auth_backend" {
  source             = "git::https://github.com/Knsan1/vault_enable_module.git//modules/vault-jwt-auth-backend-tfc" # Adjust the path if necessary
  description        = "JWT Auth Backend for my app"
  path               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
  policy_name        = "admin-policy"
  role_name          = "admin-role"
  bound_audiences    = ["vault.workload.identity"]
  bound_claims_type  = "glob"
  bound_claims = {
    sub = "organization:Hellocloud-kns:project:HCP Vault Project:workspace:*:run_phase:*"
  }
  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
  token_ttl  = 1200
}

###Enable Approle Auth on Vault(Machine/App to Vault)
module "enable_approle_auth_backend" {
  source          = "../modules/vault-approle-auth-backend/"
  policy_name     = "custom-aws-approle-policy"
  policy_document = <<EOT
path "aws-master-account/*" {
  capabilities = ["read"]
}
path "db/*" {
  capabilities = ["read"]
}
EOT
  role_name       = "custom-aws-approle"
  token_ttl       = 600
  token_max_ttl   = 1200
}


# Fetch Public Subnets in the Root Module
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = {
    Name = "public*"
  }
}

# Fetch Private Subnets in the Root Module
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = {
    Name = "private*"
  }
}

## Create SG 2 EC2 and RDS resources
module "aws_ec2_rds_instances" {
  depends_on                 = [module.hvp_vault_cluster, module.vpc, module.hvn_peering]
  source                     = "../modules/aws-ec2-rds"
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = data.aws_subnets.public.ids
  private_subnet_ids         = data.aws_subnets.private.ids
  vault_private_endpoint_url = module.hvp_vault_cluster.vault_private_endpoint
  Role_ID                    = module.enable_approle_auth_backend.role_id
  Secret_ID                  = module.enable_approle_auth_backend.secret_id
  hvn_cidr                   = module.hvp_vault_cluster.hvn_cidr_block
  instance_profile_id        = module.vault-aws-auth.int_profile_name
}

# ## Create SG EC2 under Public Subnet
# module "sg_ec2_instance" {
#   source        = "git::https://github.com/Knsan1/vault_enable_module.git///modules/aws-simple-ec2"
#   region        = module.vpc.aws_region   # Using the same region from the VPC module
#   ami           = "ami-01811d4912b4ccb26" # SG Region Ubuntu AMI ID
#   instance_type = "t2.micro"
#   key_name      = "sg-ec2-keypair" # Create keypair manually first
#   vpc_id        = module.vpc.vpc_id
#   subnet_id     = module.vpc.public_subnet_ids[0] # Replace with your subnet ID
#   instance_name = "sg-ec2-public-instance"
# }

# ## Create SG EC2 under Private Subnet
# module "sg_ec2_private_instance" {
#   source        = "git::https://github.com/Knsan1/vault_enable_module.git///modules/aws-simple-ec2"
#   region        = module.vpc.aws_region   # Using the same region from the VPC module
#   ami           = "ami-01811d4912b4ccb26" # SG Region Ubuntu AMI ID
#   instance_type = "t2.micro"
#   key_name      = "sg-ec2-keypair" # Create keypair manually first
#   vpc_id        = module.vpc.vpc_id
#   subnet_id     = module.vpc.private_subnet_ids[0] # Replace with your subnet ID
#   instance_name = "sg-ec2-private-instance"
# }

# ## Create SG EC2 under DB Subnet
# module "sg_ec2_db_instance" {
#   source        = "git::https://github.com/Knsan1/vault_enable_module.git///modules/aws-simple-ec2"
#   region        = module.vpc.aws_region   # Using the same region from the VPC module
#   ami           = "ami-01811d4912b4ccb26" # SG Region Ubuntu AMI ID
#   instance_type = "t2.micro"
#   key_name      = "sg-ec2-keypair" # Create keypair manually first
#   vpc_id        = module.vpc.vpc_id
#   subnet_id     = module.vpc.db_subnet_ids[0] # Replace with your subnet ID
#   instance_name = "sg-ec2-db-instance"
# }

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

# resource "time_sleep" "wait_before_creating_db_role" {
#   depends_on      = [module.aws_ec2_rds_instances]
#   create_duration = "60s"
# }

# ## Eanble DB Secret Engine on Vault Cluster
# module "vault_db_secrets" {
#   source     = "../modules/vault-db-dynamic-role"
#   depends_on = [time_sleep.wait_before_creating_db_role]

#   vault_token    = module.hvp_vault_cluster.vault_token_key
#   vault_address  = module.hvp_vault_cluster.vault_public_endpoint
#   path           = "db"
#   db_name        = "mysql"
#   db_username    = "vault"
#   db_password    = "vault"
#   connection_url = "{{username}}:{{password}}@tcp(${module.aws_ec2_rds_instances.rds_hostname}:3306)/"
#   allowed_roles  = ["*"]

#   readwrite_role_name   = "readwrite-role"
#   readwrite_default_ttl = 600
#   readwrite_max_ttl     = 900
#   readwrite_creation_statements = [
#     "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
#     "GRANT ALL PRIVILEGES ON projectdb.* TO '{{name}}'@'%';"
#   ]

#   readonly_role_name   = "readonly-role"
#   readonly_default_ttl = 600
#   readonly_max_ttl     = 900
#   readonly_creation_statements = [
#     "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
#     "GRANT SELECT ON projectdb.* TO '{{name}}'@'%';"
#   ]
# }