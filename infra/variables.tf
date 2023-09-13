
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  description = "stack/cluster name, used in labelling across the stack."
  type        = string
}

variable "custom_platforms" {
  description = "Platform/AMI that can be used. Can override the built in libraryy list."
  type = map(object({
    ami_name   = string
    owner      = string
    user       = string
    interface  = string
    connection = string
  }))
  default = {}
}

variable "network" {
  description = "Network configuration"
  type = object({
    cidr                 = string
    public_subnet_count  = number
    private_subnet_count = number
  })
  default = {
    cidr                 = "172.31.0.0/16"
    public_subnet_count  = 3
    private_subnet_count = 3
  }
}

variable "nodegroups" {
  description = "A map of machine group definitions"
  type = map(object({
    platform    = string
    type        = string
    count       = number
    volume_size = number
    role        = string
    public      = bool
    user_data   = string
  }))
}

// not needed if you have no windows machines
variable "windows_password" {
  description = "Windows machine password"
  sensitive   = true
  type        = string
  default     = ""
}

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

variable "mcr_version" {
  type    = string
  default = "23.0.3"
}

variable "mke_version" {
  type    = string
  default = "3.6.4"
}

variable "msr_version" {
  type    = string
  default = "2.9.2"
}

variable "mke_connect" {
  description = "MKE connection configuration"
  sensitive   = true
  type = object({
    username   = string
    password   = string
    unsafe_ssl = bool
  })
}

variable "expire_duration" {
  description = "The max time to allow this cluster to avoid early termination. Can use 'h', 'm', 's' in sane combinations, eg, '15h37m18s'."
  type        = string
  default     = "120h"
}


variable "extra_tags" {
  description = "Extra tags that will be added to all provisioned resources, where possible."
  type        = map(string)
  default     = {}
}

