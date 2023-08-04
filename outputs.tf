output "test_env"{
    value = "Domain - ${var.domain}"
}

output "test"{
    value = "Test Value- ${var.test}"
}

output "roles"{
    value = [for a in var.roles : upper(a)]
}