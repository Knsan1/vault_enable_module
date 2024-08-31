# Create IAM User
resource "aws_iam_user" "this" {
  name     = var.user_name
}

# Create Access Key
resource "aws_iam_access_key" "this" {
  user     = aws_iam_user.this.name
}

# Create IAM Policy
resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "A policy for ${var.user_name}"
  policy      = var.policy_document
}

# Attach Policy to User
resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}