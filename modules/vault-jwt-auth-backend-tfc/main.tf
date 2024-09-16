resource "vault_jwt_auth_backend" "this" {
  description         = var.description
  path                = var.path
  oidc_discovery_url  = var.oidc_discovery_url
  bound_issuer        = var.bound_issuer
}

resource "vault_policy" "this" {
  name   = var.policy_name

  policy = var.policy
}

resource "vault_jwt_auth_backend_role" "admin_role" {
  backend         = vault_jwt_auth_backend.this.path
  role_name       = var.role_name
  token_policies  = [vault_policy.this.name]
  bound_audiences = var.bound_audiences
  bound_claims_type = var.bound_claims_type
  bound_claims = var.bound_claims
  user_claim    = var.user_claim
  role_type     = var.role_type
  token_ttl     = var.token_ttl
}
