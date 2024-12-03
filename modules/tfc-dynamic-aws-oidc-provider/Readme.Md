## Module usage

```hcl
module "tfc_aws_oidc" {
  source = "../modules/tfc-dynamic-aws-oidc-provider"

  aws_region           = "ap-southeast-1"
  tfc_aws_audience     = "aws.workload.identity"
  tfc_hostname         = "app.terraform.io"
  tfc_organization_name = "my-organization"
  tfc_project_name      = "My Project"
  tfc_workspace_name    = "my-workspace"

  role_name            = "my-tfc-role"
  policy_name          = "my-tfc-policy"
  policy_description   = "Policy for TFC role"
  policy_document      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "s3:*"
     ],
     "Resource": "*"
   }
 ]
}
EOF
}
```