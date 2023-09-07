provider "kubernetes" {
  host                   = var.kube_connect.host
  client_certificate     = var.kube_connect.client_certificate
  client_key             = var.kube_connect.client_key
  cluster_ca_certificate = var.kube_connect.ca_certificate
  insecure               = var.kube_connect.tlsverifydisable
}

provider "helm" {
  kubernetes {
    host                   = var.kube_connect.host
    client_certificate     = var.kube_connect.client_certificate
    client_key             = var.kube_connect.client_key
    cluster_ca_certificate = var.kube_connect.ca_certificate
    insecure               = var.kube_connect.tlsverifydisable
  }
}
