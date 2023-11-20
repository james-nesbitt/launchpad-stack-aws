
module "lb" {
  for_each var.ingresses

  source = "lb"

  ingress = each.value
  nodes = concat([for k, n in local.nodegroups_safer : n.nodes if contains(each.value.nodegroups, k)]...)
}

// calculated after the albs are generated
locals {

  // combine the ingress definition with some of the alb data
  ingresses = { for k, i in var.ingresses : k => merge(
    i
    module.lb[k],
    { nodes: concat([for k, n in local.nodegroups_safer : n.nodes if contains(each.value.nodegroups, k)]...) }
  ) }

}
