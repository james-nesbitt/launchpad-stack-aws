
// Fowise module
//
// 1. mke user generation
// 2. mke client bundle for that new user
// 3. module execution using the client bundle
//

resource "mke_user" "kube" {
  name      = "app-kube"
  full_name = "app kube"
  password  = "k8spassword" // do a better job with this
  is_admin  = true          // we need this until we sort out better access-control
}

provider "mke" {
  alias = "flowise"

  endpoint          = local.mke_url
  username          = mke_user.kube.name
  password          = mke_user.kube.password
  unsafe_ssl_client = true
}

resource "mke_clientbundle" "flowise" {
  label = "tf_app_${mke_user.kube.name}"

  provider = mke.flowise
}

module "flowise" {
  source = "./modules/flowise"

  kube_connect = {
    host               = mke_clientbundle.flowise.kube_host
    client_certificate = mke_clientbundle.flowise.client_cert
    client_key         = mke_clientbundle.flowise.private_key
    ca_certificate     = mke_clientbundle.flowise.ca_cert
    tlsverifydisable   = mke_clientbundle.flowise.kube_skiptlsverify
  }
}
