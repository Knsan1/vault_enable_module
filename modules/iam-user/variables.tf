variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "user_name" {
  description = "The name of the IAM user"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
}

variable "policy_document" {
  description = "The JSON-encoded policy document for the IAM policy"
  type        = string
}