## Module usage

```hcl
module "vault_jwt_auth_backend" {
  source            = "./vault_jwt_auth_backend" # Adjust the path if necessary
  description       = "JWT Auth Backend for my app"
  path              = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer      = "https://app.terraform.io"
  policy_name       = "admin-policy"
  role_name         = "admin-role"
  bound_audiences   = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:Hellocloud-kns:project:HCP Vault Project:workspace:*:run_phase:*"
  }
  user_claim        = "terraform_full_workspace"
  role_type         = "jwt"
  token_ttl         = 1200
}
```