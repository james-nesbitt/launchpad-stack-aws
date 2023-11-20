
output "zone_id" {
  description = "LB Zone ID"
  value = module.alb[k].lb_zone_id
}

output "id" {
  description = "LB ID"
  value = module.alb[k].lb_id
}

output "dns" {
  description = "DNS for the LB"
  value = module.alb[k].lb_dns_name
}
