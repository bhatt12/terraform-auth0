locals {
  node_version = "node18"
  actions = {
    "action1" = { name = "action1", deploy = true, trigger = "post-login", version = "v3" }
    "action2" = { name = "action2", deploy = true, trigger = "post-login", version = "v3" }
  }
}
