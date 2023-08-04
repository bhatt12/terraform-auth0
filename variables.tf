variable "domain" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "auth0_debug" {
  type = bool
}

variable "callbacks" {
  type = list(any)
}

variable "test" {
  description = "Test Variable"
  type        = string
  default     = "default from variable tf file"
}

variable "roles" {
  description = "Role Description..."
  type        = list(any)
  default     = ["CustomRole1", "CustomRole2"]
}

variable "orgs" {
  description = "Organization set"
  type        = set(string)
  default     = ["org1", "org2", "org3"]
}

variable "users" {
  description = "user data"
  type = map(object({
    name     = string
    username = string
    email    = string
    password = string
  }))
  default = {
    "user1234" = {
      name     = "PawanBhatt"
      email    = "user1234@ukg.com"
      password = "hd98d2h3d2dd_45A"
    },
    "user5678" = {
      name     = "AmitGupta"
      email    = "user5678@ukg.com"
      password = "h65euhsthtsr*D3"
    }
  }
}
