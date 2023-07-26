
provider "auth0" {
  domain = var.domain
  client_id = var.client_id
  client_secret = var.client_secret
  debug = var.auth0_debug
}