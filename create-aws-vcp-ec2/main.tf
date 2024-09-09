###US Region VPC Create###
module "us_region_vpc" {
  region             = "us-west-2"
  source             = "../modules/aws-simple-vpc"
  vpc_name           = "us-region-vpc"
  vpc_cidr           = "10.100.0.0/16"
  public_subnets     = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnets    = ["10.100.3.0/24", "10.100.4.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b"]
}

###SG Region VPC Create###
module "sg_region_vpc" {
  region             = "ap-southeast-1"
  source             = "../modules/aws-simple-vpc"
  vpc_name           = "sg-region-vpc"
  vpc_cidr           = "10.200.0.0/16"
  public_subnets     = ["10.200.1.0/24", "10.200.2.0/24"]
  private_subnets    = ["10.200.3.0/24", "10.200.4.0/24"]
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
}


module "us_ec2_instance" {
  region = "us-west-2"
  source = "../modules/aws-simple-ec2"

  ami           = "ami-05134c8ef96964280" # US Region Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "us-ec2-keypair" # Create keypair manually first
  vpc_id        = module.us_region_vpc.vpc_id
  subnet_id     = module.us_region_vpc.public_subnet_ids[0] # Replace with your subnet ID
  instance_name = "us-ec2-instance"
}


module "sg_ec2_instance" {
  region = "ap-southeast-1"
  source = "../modules/aws-simple-ec2"

  ami           = "ami-01811d4912b4ccb26" # SG Region Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "sg-ec2-keypair" # Create keypair manually first
  vpc_id        = module.sg_region_vpc.vpc_id
  subnet_id     = module.sg_region_vpc.public_subnet_ids[0] # Replace with your subnet ID
  instance_name = "sg-ec2-instance"
}


