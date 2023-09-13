
output "nodes" {
  value = local.nodegroups
}

output "ingresses" {
  value = module.provision.ingresses
}

output "mke_connect" {
  description = "Connection information for MKE"
  sensitive   = true

  value = {
    username   = var.mke_connect.username
    password   = var.mke_connect.password
    endpoint   = "https://${local.MKE_URL}"
    unsafe_ssl = var.mke_connect.unsafe_ssl
  }
}

output "launchpad_yaml" {
  description = "Yaml for launchpad config"
  sensitive   = true

  value = local.launchpad_yaml_14
}
