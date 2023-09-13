// locals calculated before the provision run
locals {
  // combine the nodegroup definition with the platform data
  nodegroups_wplatform = { for k, ngd in var.nodegroups : k => merge(ngd, local.platforms[ngd.platform]) }
}

# PROVISION MACHINES/NETWORK
module "provision" {
  source = "./provision"
  region = var.aws_region

  name = var.name
  tags = local.tags

  cidr                 = var.network.cidr
  public_subnet_count  = var.network.public_subnet_count
  private_subnet_count = var.network.private_subnet_count
  enable_vpn_gateway   = true
  enable_nat_gateway   = false

  key_path = ".ssh/"

  nodegroups = { for k, ngd in local.nodegroups_wplatform : k => {
    ami : ngd.ami
    count : ngd.count
    type : ngd.type
    root_device_name : ngd.root_device_name
    volume_size : ngd.volume_size
    role : ngd.role
    public : ngd.public
    user_data : ngd.user_data
  } }

  ingresses = var.ingresses
}

// locals calculated after the provision module is run, but before installation using launchpad
locals {
  // combine each node-group & platform definition with the provisioned nodes
  nodegroups = { for k, ngp in local.nodegroups_wplatform : k => merge({ "name" : k }, ngp, module.provision.nodegroups[k]) }
  // combine each ingress definition with the matching nodes
  ingresses = { for k, i in var.ingresses : k => merge({ "name" : k }, i, module.provision.ingresses[k]) }
}
