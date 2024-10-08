## Create VPC for SG Region
module "vpc" {
  source = "../modules/aws-vpc-with-gw/"

  aws_region         = "ap-southeast-1"
  vpc_cidr_block     = "10.20.0.0/16"
  vpc_name           = "my-vault-vpc"
  public_cidr_block  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_cidr_block = ["10.20.3.0/24", "10.20.4.0/24"]
  db_cidr_block      = ["10.20.5.0/24", "10.20.6.0/24"]
}

## Create SG EC2 under Public Subnet
module "sg_ec2_instance" {
  source        = "../modules/aws-simple-ec2"
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
  source        = "../modules/aws-simple-ec2"
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
  source        = "../modules/aws-simple-ec2"
  region        = module.vpc.aws_region   # Using the same region from the VPC module
  ami           = "ami-01811d4912b4ccb26" # SG Region Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "sg-ec2-keypair" # Create keypair manually first
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.db_subnet_ids[0] # Replace with your subnet ID
  instance_name = "sg-ec2-db-instance"
}