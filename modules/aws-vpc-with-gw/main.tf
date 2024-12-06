provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "azs" {
  state = "available"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_cidr_block)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_block[count.index]
  # availability_zone       = data.aws_availability_zones.azs.names[count.index]
  availability_zone       = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

# Public Route Table
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public_subnet_rt"
  }
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_subnet_rt.id
}

# Internet Gateway for Public Subnets
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vault-vpc GW"
  }
}

# Route for Public Subnets
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_subnet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_block[count.index]
  # availability_zone = data.aws_availability_zones.azs.names[count.index]
  availability_zone       = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]

  tags = {
    Name = "private subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

# Private Route Table
resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private_subnet_rt"
  }
}

# Associate Route Table with Private Subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_subnet_rt.id
}

# Elastic IP and NAT Gateway for Private Subnets
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "vault-vpc NGW"
  }

  depends_on = [aws_internet_gateway.gw]
}

# Private Route through NAT Gateway
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_subnet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gw.id
}

# DB Subnets
resource "aws_subnet" "db_subnet" {
  count             = length(var.db_cidr_block)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_cidr_block[count.index]
  # availability_zone = data.aws_availability_zones.azs.names[count.index]
  availability_zone       = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]

  tags = {
    Name = "db subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

# DB Route Table
resource "aws_route_table" "db_subnet_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "db_subnet_rt"
  }
}

# Associate Route Table with DB Subnets
resource "aws_route_table_association" "db" {
  count          = length(var.db_cidr_block)
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_subnet_rt.id
}

# DB Route through NAT Gateway
resource "aws_route" "db_route" {
  route_table_id         = aws_route_table.db_subnet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gw.id
}

# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-group"
  subnet_ids = aws_subnet.db_subnet[*].id

  tags = {
    Name = "Vault Cluster DB subnet group"
  }
}
