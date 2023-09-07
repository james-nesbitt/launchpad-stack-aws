
# PROVISION MACHINES/NETWORK
#
# This must provision the machine cluster on top of which the
# Mirantis containers product will be installed.
# Used here is a Mirantis maintained module which creates a
# simple AWS isolated cluster. Mirantis maintains a number of
# simple modules for various clouds.
#
# The requirements for this implementation is two fold:
#   1. The module must create a cluster of machines with
#      sufficient resource access, and network connectivity
#      for the container products to be installed.
#   2. The module must output host and ingress information
#      that can be fed into the launchpad resource. In the
#      mirantis maintained modules, we output a list of hosts
#      maps which define their role, and connectivity settings.
#      The ingress data is passed into the MKE bootstrapper
#      as a san address.
#
# This will provide the following output:
# 1. a list of hosts, each host a map including host role and
#    connection information;
# 2. the url for the MKE Load-balancer, to be used as a SAN
#    for MKE.
# 3. the url for the MSR Load-balancer.
#
module "provision" {
  source = "/home/james/Documents/Mirantis/tools/terraform-mirantis-launchpad-aws"

  aws_region = var.aws_region

  cluster_name = var.cluster_name

  master_count       = var.master_count
  master_type        = var.master_type
  master_volume_size = var.master_volume_size

  worker_count         = var.worker_count
  windows_worker_count = var.windows_worker_count
  worker_type          = var.worker_type
  worker_volume_size   = var.worker_volume_size

  msr_count = 0
}

// launchpad install from provisioned cluster
resource "launchpad_config" "cluster" {
  # Tell the launchpad provider to not bother uninstalling
  # the container products on terraform destroy operations.
  skip_destroy = true

  metadata {
    name = var.cluster_name
  }
  spec {
    cluster {
      prune = true
    }

    dynamic "host" {
      for_each = module.provision.hosts

      content {
        role = host.value.role

        # If the host map has ssh settings
        dynamic "ssh" {
          for_each = can(host.value.ssh) ? [1] : [] # one loop if there er a value

          content {
            address  = host.value.ssh.address
            user     = host.value.ssh.user
            key_path = host.value.ssh.keyPath
            port     = 22
          }
        }

        # If the host map has ssh settings
        dynamic "winrm" {
          for_each = can(host.value.winRM) ? [1] : [] # one loop if there er a value

          content {
            address   = host.value.winRM.address
            user      = host.value.winRM.user
            password  = host.value.winRM.password
            use_https = host.value.winRM.useHTTPS
            insecure  = host.value.winRM.insecure
            port      = 5985
          }
        }

      }
    }

    # MCR configuration
    mcr {
      channel             = "stable"
      install_url_linux   = "https://get.mirantis.com/"
      install_url_windows = "https://get.mirantis.com/install.ps1"
      repo_url            = "https://repos.mirantis.com"
      version             = var.mcr_version
    } // mcr

    # MKE configuration
    mke {
      admin_password = var.mke_connect.password
      admin_username = var.mke_connect.username
      image_repo     = "docker.io/mirantis"
      version        = var.mke_version
      install_flags  = ["--san=${module.provision.mke_lb}", "--default-node-orchestrator=kubernetes", "--nodeport-range=32768-35535"]
	  upgrade_flags  = ["--force-recent-backup", "--force-minimums"]

	  cloud {
		provider = "aws"
	  }
    } // mke

    # MSR configuration

    #msr {
    #  image_repo    = "docker.io/mirantis"
    #  version       = var.msr_version
    #  replica_ids   = "sequential"
    #  install_flags = ["--ucp-insecure-tls"]
    #} // msr

  } // spec
}
