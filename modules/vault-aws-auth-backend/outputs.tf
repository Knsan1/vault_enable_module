output "iam_user_name" {
  value = aws_iam_user.vault_admin.name
}

output "ec2_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "vault_role_name" {
  value = vault_aws_auth_backend_role.aws_role.role_id
}

