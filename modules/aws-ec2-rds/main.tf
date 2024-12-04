//---------------------------------------------------------
//## For JUMP server in public subnet
//---------------------------------------------------------
## Create Security Group
resource "aws_security_group" "allow_ssh_jump" {
  name        = "allow_ssh_jump"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_ssh_jump"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_jump" {
  security_group_id = aws_security_group.allow_ssh_jump.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_ssh_jump" {
  security_group_id = aws_security_group.allow_ssh_jump.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


## Create JUMP server in public subnet
resource "aws_instance" "jump" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  key_name                    = "ssh-key-${random_pet.env.id}"
  subnet_id                   = var.public_subnet_ids[0]
  security_groups             = [aws_security_group.allow_ssh_jump.id]

  tags = {
    Name = "Jump Server"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

//---------------------------------------------------------
//## Application with AWS Auth  Method
//---------------------------------------------------------
## Create Security Group
resource "aws_security_group" "allow_ssh_app" {
  name        = "allow_ssh_app"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_ssh_app"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_app" {
  for_each          = data.aws_subnet.public
  security_group_id = aws_security_group.allow_ssh_app.id
  cidr_ipv4         = each.value.cidr_block #aws_instance.jump.private_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_app" {
  security_group_id = aws_security_group.allow_ssh_app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

data "template_file" "vault_agent_aws" {
  template = file("${path.module}/template/ec2-aws-auth.tftpl")
  vars = {
    tpl_vault_server_addr = var.vault_private_endpoint_url
    MYSQL_HOST            = aws_db_instance.project_rds.address
    MYSQL_USER            = aws_db_instance.project_rds.username
    MYSQL_PASS            = aws_db_instance.project_rds.password
  }
}

## Create JUMP server in public subnet
resource "aws_instance" "app_aws" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  key_name             = "ssh-key-${random_pet.env.id}"
  subnet_id            = var.private_subnet_ids[0]
  security_groups      = [aws_security_group.allow_ssh_app.id]
  iam_instance_profile = var.instance_profile_id
  user_data            = data.template_file.vault_agent_aws.rendered

  tags = {
    Name = "App Server"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

//---------------------------------------------------------
//## Application with AppRole Auth  Method
//---------------------------------------------------------
data "template_file" "vault_agent_approle" {
  template = file("${path.module}/template/ec2-approle-auth.tftpl")
  vars = {
    tpl_vault_server_addr = var.vault_private_endpoint_url
    login_role_id         = var.Role_ID
    login_secret_id       = var.Secret_ID
  }
}

## Create JUMP server in public subnet
resource "aws_instance" "app_approle" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = "ssh-key-${random_pet.env.id}"
  subnet_id       = var.private_subnet_ids[1]
  security_groups = [aws_security_group.allow_ssh_app.id]
  user_data       = data.template_file.vault_agent_approle.rendered

  tags = {
    Name = "Approle Server"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

//---------------------------------------------------------
//## Create RDS instance
//---------------------------------------------------------
## Create Security Group
resource "aws_security_group" "allow_db" {
  name        = "allow_db"
  description = "Allow db inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_db"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_db_app" {
  for_each          = data.aws_subnet.private
  security_group_id = aws_security_group.allow_db.id
  cidr_ipv4         = each.value.cidr_block #aws_instance.jump.private_ip
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_ingress_rule" "allow_db_vault" {
  security_group_id = aws_security_group.allow_db.id
  cidr_ipv4         = var.hvn_cidr
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}


resource "aws_vpc_security_group_egress_rule" "allow_db_app" {
  security_group_id = aws_security_group.allow_db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

##Create RDS 
resource "aws_db_instance" "project_rds" {
  allocated_storage      = 10
  db_name                = "projectdb"
  engine                 = "mysql"
  engine_version         = "8.0"
  db_subnet_group_name   = "db-group"
  identifier             = "db-instance"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "Admin1234"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.allow_db.id]
}