// prepare values to make it easier to feed into launchpad
locals {
  // The SAN URL for the MKE load balancer ingress that is for the MKE load balancer
  MKE_URL = local.ingresses["mke"].lb_dns_name

  // flatten nodegroups into a set of oblects with the info needed for each node, by combining the group details with the node detains
  launchpad_hosts = concat([for k, ng in local.nodegroups : [for l, ngn in ng.nodes : {
    label : ngn.label

    role : ng.role
    address : ngn.public_ip // ngn.public_address

    key_path : ngn.key_path_abs // ngn.key_path

    connection : ng.connection

    ssh_user : try(ng.ssh_user, "")
    ssh_port : try(ng.ssh_port, "")

    winrm_user : try(ng.winrm_user, "")
  }]]...)

  // decide if we need msr configuration
  has_msr = length([for k, lh in local.launchpad_hosts : lh if lh.role == "msr"]) > 0
}

//// launchpad install from provisioned cluster
resource "launchpad_config" "cluster" {
  # Tell the launchpad provider to not bother uninstalling
  # the container products on terraform destroy operations.
  skip_destroy = var.mke_skip_uninstall
  skip_create  = var.mke_skip_install

  metadata {
    name = var.name
  }

  spec {
    cluster {
      prune = true
    }

    // ssh hosts
    dynamic "host" {
      for_each = [for k, lh in local.launchpad_hosts : lh if lh.connection == "ssh"]

      content {
        role = host.value.role
        ssh {
          address  = host.value.address
          user     = host.value.ssh_user
          key_path = host.value.key_path
        }
      }
    }

    // winrm hosts
    dynamic "host" {
      for_each = [for k, lh in local.launchpad_hosts : lh if lh.connection == "winrm "]

      content {
        role = host.value.role
        ssh {
          address  = host.value.address
          user     = host.value.winrm_user
          password = var.windows_password
          useHTTPS = false
          insecure = false
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
      install_flags = [
        "--san=${local.MKE_URL}",
        "--default-node-orchestrator=kubernetes",
        "--nodeport-range=32768-35535"
      ]
      upgrade_flags = [
        "--force-recent-backup",
        "--force-minimums"
      ]
      cloud {
        provider = "aws"
      }
    } // mke

    # MSR configuration
    dynamic "msr" {
      for_each = length([for k, lh in local.launchpad_hosts : lh if lh.role == "msr"]) > 0 ? [1] : []

      content {
        image_repo  = "docker.io/mirantis"
        version     = var.msr_version
        replica_ids = "sequential"
        install_flags = [
          "--ucp-insecure-tlsG"
        ]
      }
    } // msr

  } // spec
}

// ------- Ye old launchpad yaml (just for debugging)

locals {
  launchpad_yaml_14 = <<-EOT
apiVersion: launchpad.mirantis.com/mke/v1.4
kind: mke%{if local.has_msr}+msr%{endif}
metadata:
  name: ${var.name}
spec:
  cluster:
    prune: false
  hosts:
%{~for h in local.launchpad_hosts}
  # ${h.label}
  - role: ${h.role}
%{~if h.connection == "ssh"}
    ssh:
      address: ${h.address}
      user: ${h.ssh_user}
      keyPath: ${h.key_path}
%{~endif}
%{~if h.connection == "winrm"}
    winrm:
      address: ${h.address}
      user: ${h.winrm_user}
      password: ${var.windows_password}
      useHTTPS: false
      insecure: true
%{~endif}
%{~endfor}
  mke:
    version: ${var.mke_version}
    imageRepo: docker.io/mirantis
    adminUsername: ${var.mke_connect.username}
    adminPassword: ${var.mke_connect.password}
    installFlags: 
    - "--san=${local.MKE_URL}"
    - "--default-node-orchestrator=kubernetes"
    - "--nodeport-range=32768-35535"
    upgradeFlags:
    - "--force-recent-backup"
    - "--force-minimums"
    cloud:
      provider: aws
  mcr:
    version: ${var.mcr_version}
    repoURL: https://repos.mirantis.com
    installURLLinux: https://get.mirantis.com/
    installURLWindows: https://get.mirantis.com/install.ps1
    channel: stable
EOT

}
