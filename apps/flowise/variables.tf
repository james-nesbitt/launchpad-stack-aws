
variable "mke_connect" {
  description = "MKE connection configuration"
  type = object({
    username = string
    password = string
  })
}
