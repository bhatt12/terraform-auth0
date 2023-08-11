#---------------------Auth0 Clients---------------------------------------

#--------------------SPA Client-------------------------------------------
resource "auth0_client" "loginclient" {
  name                                = "loginclient"
  description                         = "Login Client"
  app_type                            = "spa"
  custom_login_page_on                = true
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = false
  oidc_conformant                     = true
  callbacks                           = var.callbacks
  allowed_origins                     = ["https://example.com"]
  allowed_logout_urls                 = ["https://example.com"]
  web_origins                         = ["https://example.com"]
  grant_types = [
    "authorization_code",
    "http://auth0.com/oauth/grant-type/password-realm",
    "implicit",
    "password",
    "refresh_token"
  ]
  client_metadata = {
    foo = "zoo"
  }

  jwt_configuration {
    lifetime_in_seconds = 300
    secret_encoded      = true
    alg                 = "RS256"
    scopes = {
      foo = "bar"
    }
  }

  refresh_token {
    leeway          = 0
    token_lifetime  = 2592000
    rotation_type   = "rotating"
    expiration_type = "expiring"
  }

  mobile {
    ios {
      team_id               = "9JA89QQLNQ"
      app_bundle_identifier = "com.my.bundle.id"
    }
  }

  addons {
    samlp {
      audience = "https://example.com/saml"
      issuer   = "https://example.com"
      mappings = {
        email = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
        name  = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
      }
      create_upn_claim                   = false
      passthrough_claims_with_no_mapping = false
      map_unknown_claims_as_is           = false
      map_identities                     = false
      name_identifier_format             = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"
      name_identifier_probes = [
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
      ]
      signing_cert = "-----BEGIN PUBLIC KEY-----\nMIGf...bpP/t3\n+JGNGIRMj1hF1rnb6QIDAQAB\n-----END PUBLIC KEY-----\n"
    }
  }
}

#------------------------------Client Credential M2M Client----------------------------------------------

resource "auth0_client" "clientcred-m2m-client" {
  name                                = "clientcred-m2m-client"
  description                         = "Test Applications For Client Credential"
  app_type                            = "non_interactive"
  custom_login_page_on                = true
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = false
  oidc_conformant                     = true
  callbacks                           = var.callbacks
  allowed_origins                     = ["https://example.com"]
  allowed_logout_urls                 = ["https://example.com"]
  web_origins                         = ["https://example.com"]
  grant_types = [
    "client_credentials",
    "refresh_token"
  ]
  client_metadata = {
    foo = "zoo"
  }

  jwt_configuration {
    lifetime_in_seconds = 300
    secret_encoded      = true
    alg                 = "RS256"
    scopes = {
      foo = "bar"
    }
  }

  refresh_token {
    leeway          = 0
    token_lifetime  = 2592000
    rotation_type   = "rotating"
    expiration_type = "expiring"
  }

  mobile {
    ios {
      team_id               = "9JA89QQLNQ"
      app_bundle_identifier = "com.my.bundle.id"
    }
  }

  addons {
    samlp {
      audience = "https://example.com/saml"
      issuer   = "https://example.com"
      mappings = {
        email = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
        name  = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
      }
      create_upn_claim                   = false
      passthrough_claims_with_no_mapping = false
      map_unknown_claims_as_is           = false
      map_identities                     = false
      name_identifier_format             = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"
      name_identifier_probes = [
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
      ]
      signing_cert = "-----BEGIN PUBLIC KEY-----\nMIGf...bpP/t3\n+JGNGIRMj1hF1rnb6QIDAQAB\n-----END PUBLIC KEY-----\n"
    }
  }
}

#-----------------------------------------Actions--------------------------------------------------------------------
resource "auth0_action" "action1" {
  name    = format("Test Action %s", timestamp())
  runtime = "node18"
  deploy  = true
  code    = <<-EOT
  /**
   * Handler that will be called during the execution of a PostLogin flow.
   *
   * @param {Event} event - Details about the user and the context in which they are logging in.
   * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
   */
   exports.onExecutePostLogin = async (event, api) => {
     console.log(event);
   };
  EOT

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }

  dependencies {
    name    = "lodash"
    version = "latest"
  }

  dependencies {
    name    = "request"
    version = "latest"
  }

  secrets {
    name  = "FOO"
    value = "Foo"
  }

  secrets {
    name  = "BAR"
    value = "Bar"
  }
}

#----------------------------------Role-----------------------------------------------------------------

resource "auth0_role" "my_role" {

  description = "Role Description..."
  count       = 2
  name        = "My Role ${count.index}- (Managed by Terraform)"
}

resource "auth0_role" "custom_role" {

  description = "Role Description..."
  count       = length(var.roles)
  name        = var.roles[count.index]
}

#-----------------------------------Org------------------------------------------------------------------------
resource "auth0_organization" "my_organization" {
  for_each     = var.orgs
  name         = each.value
  display_name = each.value

  branding {
    logo_url = "https://example.com/assets/icons/icon.png"
    colors = {
      primary         = "#f2f2f2"
      page_background = "#e1e1e1"
    }
  }
}

#-----------------------------------User------------------------------------------------------------------------
resource "auth0_user" "user" {
  for_each        = var.users
  connection_name = "Username-Password-Authentication"
  name            = each.value.name
  email           = each.value.email
  email_verified  = true
  password        = each.value.password
  picture         = "https://www.example.com/a-valid-picture-url.jpg"
}

#-----------------------------------Action-------------------------------------------------------------------
resource "auth0_action" "my_action" {

  for_each = local.actions
  name     = "${each.key}-${timestamp()}"
  runtime  = local.node_version
  deploy   = each.value.deploy
  code     = file("${path.module}/external/actions/${each.key}.js")

  supported_triggers {
    id      = each.value.trigger
    version = each.value.version
  }

  dependencies {
    name    = "lodash"
    version = "latest"
  }

  dynamic "secrets" {
    for_each = var.secrets
    content {
      name  = secrets.key
      value = secrets.value
    }
  }
}
