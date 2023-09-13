
locals {
  // this is the idea of @jcarrol who put this into a lib map. Here we steal his idea
  lib_platform_definitions = {
    "ubuntu_20.04" : {
      "ami_name" : "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*",
      "owner" : "099720109477",
      "interface" : "ens5",
      "connection" : "ssh",
      "ssh_user" : "ubuntu",
      "ssh_port" : 22
    },
    "ubuntu_22.04" : {
      "ami_name" : "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*",
      "owner" : "099720109477",
      "interface" : "ens5",
      "connection" : "ssh",
      "ssh_user" : "ubuntu",
      "ssh_port" : 22
    }
  }

  // combine our library of platforms with any custom platforms that may have been given
  platform_definitions = merge(local.lib_platform_definitions, var.custom_platforms)

  // find the unique platforms actually used in the node_group_definitions, so that we can combine platform definiton and ami data together
  // - this is unique to avoid repeated ami pulls for the same definition
  // - only node-group platforms are pulled to avoid pulling images data sources that are not used anywhere
  unique_used_platform_definitions = { for up in distinct([for ngd in var.nodegroups : ngd.platform]) : up => local.platform_definitions[up] }
}

data "aws_ami" "platform" {
  for_each = local.unique_used_platform_definitions

  most_recent = true
  owners      = [each.value.owner]
  filter {
    name   = "name"
    values = [each.value.ami_name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// variables calculated after ami data is pulled
locals {
  // combine ami/plaftorm data per unique platforms
  platforms = { for k, upd in local.unique_used_platform_definitions : k => merge(upd, {
    ami : data.aws_ami.platform[k].image_id
    root_device_name : data.aws_ami.platform[k].root_device_name
  }) }
}


// ami = {
//   "architecture" = "x86_64"
//   "arn" = "arn:aws:ec2:us-east-2::image/ami-00d5c4dd05b5467c4"
//   "block_device_mappings" = toset([
//     {
//       "device_name" = "/dev/sda1"
//       "ebs" = tomap({
//         "delete_on_termination" = "true"
//         "encrypted" = "false"
//         "iops" = "0"
//         "snapshot_id" = "snap-0258cb9fcaf3a7fa9"
//         "throughput" = "0"
//         "volume_size" = "8"
//         "volume_type" = "gp2"
//       })
//       "no_device" = ""
//       "virtual_name" = ""
//     },
//     {
//       "device_name" = "/dev/sdb"
//       "ebs" = tomap({})
//       "no_device" = ""
//       "virtual_name" = "ephemeral0"
//     },
//     {
//       "device_name" = "/dev/sdc"
//       "ebs" = tomap({})
//       "no_device" = ""
//       "virtual_name" = "ephemeral1"
//     },
//   ])
//   "boot_mode" = "legacy-bios"
//   "creation_date" = "2023-09-07T04:28:31.000Z"
//   "deprecation_time" = "2025-09-07T04:28:31.000Z"
//   "description" = "Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-09-07"
//   "ena_support" = true
//   "executable_users" = tolist(null) /* of string */
//   "filter" = toset([
//     {
//       "name" = "name"
//       "values" = toset([
//         "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*",
//       ])
//     },
//     {
//       "name" = "virtualization-type"
//       "values" = toset([
//         "hvm",
//       ])
//     },
//   ])
//   "hypervisor" = "xen"
//   "id" = "ami-00d5c4dd05b5467c4"
//   "image_id" = "ami-00d5c4dd05b5467c4"
//   "image_location" = "amazon/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230907"
//   "image_owner_alias" = "amazon"
//   "image_type" = "machine"
//   "imds_support" = ""
//   "include_deprecated" = false
//   "kernel_id" = ""
//   "most_recent" = true
//   "name" = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230907"
//   "name_regex" = tostring(null)
//   "owner_id" = "099720109477"
//   "owners" = tolist([
//     "099720109477",
//   ])
//   "platform" = ""
//   "platform_details" = "Linux/UNIX"
//   "product_codes" = toset([])
//   "public" = true
//   "ramdisk_id" = ""
//   "root_device_name" = "/dev/sda1"
//   "root_device_type" = "ebs"
//   "root_snapshot_id" = "snap-0258cb9fcaf3a7fa9"
//   "sriov_net_support" = "simple"
//   "state" = "available"
//   "state_reason" = tomap({
//     "code" = "UNSET"
//     "message" = "UNSET"
//   })
//   "tags" = tomap({})
//   "timeouts" = null /* object */
//   "tpm_support" = ""
//   "usage_operation" = "RunInstances"
//   "virtualization_type" = "hvm"
// }
// 
