
output "vpc" {
  value = module.vpc
}

output "nodegroups" {
  value = local.nodegroups_safer
}

output "ingresses" {
  description = "node group ingress details"
  value = local.ingresses
}

output "key_path" {
  description = "path to the machine ssh private key"
  value = var.key_path
}
