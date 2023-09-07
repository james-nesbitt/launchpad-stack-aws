
variable "kube_connect" {
  description = "host and keys and certificates used for kubernetes interactions"
  type = object({
    host               = string
    client_certificate = string
    client_key         = string
    ca_certificate     = string
    tlsverifydisable   = bool
  })
}
