
variable "name" {
  description = "cluster/stack name used for identification"
  type        = string
}

# ===  Networking ===

variable "cidr" {
  description = "cidr for the stack internal network"
  type        = string
  default     = "172.31.0.0/16"
}

variable "tags" {
  description = "tags to be applied to created resources"
  type        = map(string)
}

variable "region" {
  description = "AWS Region to create resources in"
  type    = string
  default = "us-east-1"
}

variable "public_subnet_count" {
  description = "How many public subnets to create. Subnets will be spread accross region AZs"
  type        = number
  default     = 3
}

variable "private_subnet_count" {
  description = "How many private subnets to create. Subnets will be spread accross region AZs"
  type        = number
  default     = 3
}

variable "enable_nat_gateway" {
  description = "Should a NAT gateway be included in the cluster"
  type        = bool
  default     = false
}

variable "enable_vpn_gateway" {
  description = "Should a VPN gateway be included in the cluster"
  type        = bool
  default     = false
}

# === Machines ===

variable "ingresses" {
  description = "Configure ingress (ALB) for specific nodegroup roles"
  type = map(object({
    nodegroups    = list(string)
    node_port     = number
    node_protocol = string

    listen_http_port     = number
    listen_http_protocol = string
  }))
  default = {}
}

variable "nodegroups" {
  description = "A map of machine group definitions"
  type = map(object({
    ami              = string
    type             = string
    count            = number
    root_device_name = string
    volume_size      = number
    role             = string
    public           = bool
    user_data        = string
  }))
  default = {}
}

variable "key_path" {
  description = "Path to store SSH Keys generated"
  type        = string
  default     = "ssh"
}

variable "ssh_algorithm" {
  description = "SSH Key algortythm (rsa or ed25519)"
  type        = string
  default     = "ed25519"
}
