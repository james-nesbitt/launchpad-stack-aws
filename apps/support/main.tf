
# Now that we have a user we build an mke provider/client-bundle on it.
provider "mke" {
  alias = "infrasupport"

  endpoint          = local.mke_connect.endpoint
  unsafe_ssl_client = local.mke_connect.unsafe_ssl
  username          = mke_user.infrasupport.name
  password          = mke_user.infrasupport.password
}

resource "mke_clientbundle" "support" {
  label = "tf_infra_support"

  provider = mke.infrasupport
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
