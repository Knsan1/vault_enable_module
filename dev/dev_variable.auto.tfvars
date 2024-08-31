aws_region      = "ap-southeast-1"
user_name       = "dev-master-vault-admin"
policy_name     = "dev-vault-user-policy"
vault_path      = "dev/master-admin"
vault_token     = "root"
vault_address   = "https://0.0.0.0:8200"
policy_name1    = "iam-user-policy"
static_iam_user = "dev-static-user"
policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachUserPolicy",
        "iam:CreateAccessKey",
        "iam:CreateUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:GetUser",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:AddUserToGroup",
        "iam:RemoveUserFromGroup"
      ],
      "Resource": [
        "arn:aws:iam::730335624063:user/*"
      ]
    }
  ]
}
EOF

