
variable "key" {
  description = "String identifier for the ingress"
  type = string
}

variable "ingress" {
  description = "Configure ingress (ALB) for specific nodegroup roles"
  type = object({
    nodegroups    = list(string)
    node_port     = number
    node_protocol = string

    listen = map(object({
      port = integers
      protocl = string
    }))
  })
}

variable "nodes" {
  description = "List of nodes that should be connected to the LB"
  type = list(object{

  })
}

variable "tags" {
  description = "tags to be applied to created resources"
  type        = map(string)
}
