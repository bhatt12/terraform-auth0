terraform {
  required_providers {
    auth0={
        source = "auth0/auth0"
        version = "1.0.0-beta.0"
    }
  }
}

provider "auth0" {
  domain = var.domain
  client_id = var.client_id
  client_secret = var.client_secret
  debug = var.auth0_debug
}