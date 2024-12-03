variable "tfc_aws_audience" {
  type        = string
  description = "The audience value to use in run identity tokens"
  default     = "aws.workload.identity"
}

variable "tfc_hostname" {
  type        = string
  description = "The hostname of the TFC or TFE instance you'd like to use with AWS"
  default     = "app.terraform.io"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_project_name" {
  type        = string
  description = "The project under which a workspace will be created"
  default     = "Default Project"
}

variable "tfc_workspace_name" {
  type        = string
  description = "The name of the workspace to connect to AWS"
  default     = "dynamic-credentials-trust-relationship"
}

variable "aws_region" {
  type        = string
  description = "AWS region for all resources"
  default     = "us-east-2"
}

variable "role_name" {
  type        = string
  description = "IAM Role name"
  default     = "tfc-role"
}

variable "policy_name" {
  type        = string
  description = "IAM Policy name"
  default     = "tfc-policy"
}

variable "policy_description" {
  type        = string
  description = "IAM Policy description"
  default     = "TFC run policy"
}

variable "policy_document" {
  type        = string
  description = "IAM Policy document in JSON format"
  default     = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "ec2:*"
     ],
     "Resource": "*"
   }
 ]
}
EOF
}
