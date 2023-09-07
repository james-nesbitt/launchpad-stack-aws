# Configure the MKE Provider
provider "mke" {
  endpoint          = local.mke_url
  username          = var.mke_connect.username
  password          = var.mke_connect.password
  unsafe_ssl_client = true
}
