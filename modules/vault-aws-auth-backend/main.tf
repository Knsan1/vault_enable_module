# Create IAM User
resource "aws_iam_user" "vault_admin" {
  name = var.user_name
  path = var.user_path
}

# Create IAM Access Key
resource "aws_iam_access_key" "vault_admin_key" {
  user = aws_iam_user.vault_admin.name
}

# Policy for Vault AWS Auth Method
data "aws_iam_policy_document" "vault_auth_policy" {
  statement {
    sid       = "VaultAWSAuthMethod"
    effect    = "Allow"
    actions   = var.actions
    resources = ["*"]
  }
}

# Attach Policy to User
resource "aws_iam_user_policy" "vault_auth_policy" {
  name   = var.policy_name
  user   = aws_iam_user.vault_admin.name
  policy = data.aws_iam_policy_document.vault_auth_policy.json
}

# IAM Role for EC2
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = var.ec2_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "vault_client_instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.ec2_role.id
}

# Vault Auth Backend and Client
resource "vault_auth_backend" "aws" {
  type = "aws"
}

resource "vault_aws_auth_backend_client" "aws_client" {
  backend    = vault_auth_backend.aws.path
  access_key = aws_iam_access_key.vault_admin_key.id
  secret_key = aws_iam_access_key.vault_admin_key.secret
}

# Vault Policy for DB Access
resource "vault_policy" "db_policy" {
  name   = var.vault_policy_name
  policy = var.vault_policy_document
}

# Ensure IAM Role is Created First
resource "time_sleep" "wait_before_creating_role" {
  depends_on      = [aws_iam_role.ec2_role]
  create_duration = "60s"
}

# Vault AWS Auth Backend Role
resource "vault_aws_auth_backend_role" "aws_role" {
  depends_on               = [time_sleep.wait_before_creating_role]
  backend                  = vault_auth_backend.aws.path
  role                     = var.vault_role_name
  auth_type                = "iam"
  bound_iam_principal_arns = [aws_iam_role.ec2_role.arn]
  token_ttl                = var.token_ttl
  token_max_ttl            = var.token_max_ttl
  token_policies           = [vault_policy.db_policy.name]
}
