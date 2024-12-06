data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


###Reading Output Data from workspace state 
# data "terraform_remote_state" "vpc" {
#   backend = "remote"
#   config = {
#     organization = "Hellocloud-kns"
#     workspaces = {
#       name = "create-aws-vpc_Step04"
#     }
#   }
# }


# # Public Subnets
# data "aws_subnet" "public" {
#   for_each = { for idx, id in var.public_subnet_ids : idx => id }
#   id       = each.value
# }

# # Private Subnets
# data "aws_subnet" "private" {
#   for_each = { for idx, id in var.private_subnet_ids : idx => id }
#   id       = each.value
# }

data "aws_subnet" "public" {
  for_each = var.public_subnet_ids

  id = each.value
}

data "aws_subnet" "private" {
  for_each = var.private_subnet_ids

  id = each.value
}
# 

# ###Reading VPC Account ID Info
# data "aws_vpc" "selected" {
#   id = var.vpc_id
# }

# # data "aws_arn" "vpc_region" {
# #   arn = data.aws_vpc.selected.arn
# # }

# ###For Public Subnet filter specifice zone
# data "aws_subnets" "public" {
#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }

#   tags = {
#     Name = "public*"
#   }
# }

# data "aws_subnet" "public" {
#   for_each = toset(data.aws_subnets.public.ids)
#   id       = each.value
# }

# ###For Public Subnet filter specifice zone
# data "aws_subnets" "private" {
#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }

#   tags = {
#     Name = "private*"
#   }
# }

# data "aws_subnet" "private" {
#   for_each = toset(data.aws_subnets.private.ids)
#   id       = each.value
# }



# ###Reading Output Data from workspace state for IAM ROLE
# data "terraform_remote_state" "iam" {
#   backend = "remote"
#   config = {
#     organization = "Hellocloud-kns"
#     workspaces = {
#       name = "enable_aws_auth_on_vault_Step06"
#     }
#   }
# }

# ###Reading Output Data from workspace state for vault-cluster
# data "terraform_remote_state" "vault_cluster" {
#   backend = "remote"
#   config = {
#     organization = "Hellocloud-kns"
#     workspaces = {
#       name = "vault-cluster_step01"
#     }
#   }
# }

# ###Reading Output Data from workspace state for Approle-outputs
# data "terraform_remote_state" "approle" {
#   backend = "remote"
#   config = {
#     organization = "Hellocloud-kns"
#     workspaces = {
#       name = "enable_approle_auth_method_Step07"
#     }
#   }
# }