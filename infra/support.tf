
# Configure the MKE Provider
provider "mke" {
  endpoint          = "https://${module.provision.mke_lb}"
  username          = var.mke_connect.username
  password          = var.mke_connect.password
  unsafe_ssl_client = true
}

resource "mke_clientbundle" "support" {
  label = "tf_infra_support"

  depends_on = [launchpad_config.cluster]
}

module "support-aws-ebs-csi" {
  source = "./support/aws-ebs-csi"

  kube_connect = {
    host               = mke_clientbundle.support.kube_host
    client_certificate = mke_clientbundle.support.client_cert
    client_key         = mke_clientbundle.support.private_key
    ca_certificate     = mke_clientbundle.support.ca_cert
    tlsverifydisable   = mke_clientbundle.support.kube_skiptlsverify
  }
}
