## This Terraform code can use to create Organization, Project and Workspaces[Connect to Github Repo] in Terraform Cloud(TFC)
### Need to export TFC and Github Token as ENV variable for VCS WorkFlow
```
## Github account Token(classic) Full Repo Access
$ export TF_VAR_github_oauth_token="ghpxxxxxxxxxxxxxx"
## TFC Account Level Token
$ export TFE_TOKEN="xxxxxxxxxxxxxx"
## Check exproted token
$ export | grep -i token