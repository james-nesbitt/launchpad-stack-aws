
module "nodegroups" {
  for_each = var.nodegroups

  source = "./nodegroup"

  name = "${var.name}-${each.key}"

  ami              = each.value.ami
  type             = each.value.type
  node_count       = each.value.count
  root_device_name = each.value.root_device_name
  volume_size      = each.value.volume_size
  user_data        = each.value.user_data

  key_pair = aws_key_pair.common.id

  subnets         = each.value.public ? module.vpc.public_subnets : module.vpc.private_subnets
  security_groups = [aws_security_group.common.id]

  tags = merge({
    stack = var.name
    },
    var.tags
  )
}

// locals created after node groups are provisioned.
locals {
  // combine node-group asg & node information after creation
  nodegroups = { for k, ng in var.nodegroups : k => merge(ng, {
    nodes : module.nodegroups[k].nodes
  }) }

  // a safer nodegroup listing that doesn't have any sensitive data.
  nodegroups_safer = { for k, ng in var.nodegroups : k => merge(ng, {
    nodes : [for j, i in module.nodegroups[k].nodes : {
      nodegroup       = k
      index           = j
      id              = "${k}-${j}"
      label           = "${var.name}-${k}-${j}"
      instance_id     = i.instance_id
      key             = aws_key_pair.common.key_name
      key_path        = local_file.common_ssh_public_key.filename
      key_path_abs    = abspath(local_file.common_ssh_public_key.filename)
      key_sha512      = local_file.common_ssh_public_key.content_sha512
      private_ip      = i.private_ip
      private_dns     = i.private_dns
      private_address = trimspace(coalesce(i.private_dns, i.private_ip, " "))
      public_ip       = i.public_ip
      public_dns      = i.public_dns
      public_address  = trimspace(coalesce(i.public_dns, i.public_ip, " "))
    }]
  }) }
}

