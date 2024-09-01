# hellocloud-aws-master-account
output "aws_dynamic_user_id" {
  description = "Unique identifier of the calling entity"
  value       = data.aws_caller_identity.dynamic_iam_user.user_id
}

output "aws_dynamic_id" {
  description = "Account ID number of the account that owns or contains the calling entity."
  value       = data.aws_caller_identity.dynamic_iam_user.id
}

output "aws_dynamic_user_arn" {
  description = "ARN associated with the calling entity."
  value       = data.aws_caller_identity.dynamic_iam_user.arn
}
