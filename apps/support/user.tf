# Configure the MKE Provider
provider "mke" {
  endpoint          = local.mke_connect.endpoint
  unsafe_ssl_client = local.mke_connect.unsafe_ssl
  username          = local.mke_connect.username
  password          = local.mke_connect.password
}

# Make an MKE user for all of the support tooling
resource "mke_user" "infrasupport" {
  name     = "infrasupport"
  password = local.mke_connect.password // this should be optional
  is_admin = true
}
