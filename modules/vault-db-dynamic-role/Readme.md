# Module Usage
```
module "vault_db_secrets" {
  source = "./vault-db-secrets"

  path                          = "db"
  db_name                       = "mysql"
  db_username                   = "vault"
  db_password                   = "vault"
  connection_url                = "{{username}}:{{password}}@tcp(${data.terraform_remote_state.rds.outputs.rds_hostname}:3306)/"
  allowed_roles                 = ["*"]

  readwrite_role_name           = "readwrite-role"
  readwrite_default_ttl         = 600
  readwrite_max_ttl             = 900
  readwrite_creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT ALL PRIVILEGES ON projectdb.* TO '{{name}}'@'%';"
  ]

  readonly_role_name            = "readonly-role"
  readonly_default_ttl          = 600
  readonly_max_ttl              = 900
  readonly_creation_statements  = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT SELECT ON projectdb.* TO '{{name}}'@'%';"
  ]
}
```