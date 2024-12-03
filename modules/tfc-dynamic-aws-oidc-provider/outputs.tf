output "openid_claims" {
  description = "OpenID Claims for trust relationship"
  value       = one(jsondecode(aws_iam_role.tfc_role.assume_role_policy).Statement).Condition
}

output "role_arn" {
  description = "ARN for the IAM role used for the trust relationship"
  value       = aws_iam_role.tfc_role.arn
}

output "openid_connect_provider_arn" {
  description = "ARN of the OIDC provider"
  value       = aws_iam_openid_connect_provider.tfc_provider.arn
}

output "policy_arn" {
  description = "ARN of the IAM policy attached to the role"
  value       = aws_iam_policy.tfc_policy.arn
}
