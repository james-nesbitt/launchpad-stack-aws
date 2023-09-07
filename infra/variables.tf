
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type = string
}

variable "master_type" {
  type    = string
  default = "r5.4xlarge"
}
variable "master_count" {
  type = number
}
variable "master_volume_size" {
  default = 100
}

variable "worker_type" {
  type    = string
  default = "m5.2xlarge"
}
variable "worker_count" {
  type = number
}
variable "windows_worker_count" {
  type = number
}
variable "worker_volume_size" {
  default = 100
}

variable "mcr_version" {
  type    = string
  default = "23.0.3"
}

variable "mke_version" {
  type    = string
  default = "3.6.4"
}
variable "mke_connect" {
  description = "MKE connection configuration"
  type = object({
    username = string
    password = string
  })
}

variable "msr_version" {
  type    = string
  default = "2.9.2"
}
