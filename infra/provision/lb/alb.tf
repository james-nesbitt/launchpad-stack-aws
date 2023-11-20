
module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = "${var.stack}-${var.name}"

  load_balancer_type = "network"

  vpc_id  = module.vpc.vpc_id

  # Use `subnet_mapping` to attach EIPs
  subnet_mapping = [for i, eip in aws_eip.this :
    {
      allocation_id = eip.id
      subnet_id     = module.vpc.private_subnets[i]
    }
  ]
  
  tags = merge({
    stack = var.stack
    role  = "lb"
    unit  = var.name
  }, var.tags)
}

resource "aws_eip" "this" {
  count = length(var.azs)

  domain = "vpc"
}

//"alb" = {
//      "http_tcp_listener_arns" = [
//        "arn:aws:elasticloadbalancing:us-east-1:485146132295:listener/app/jntest-mke/8208e898cb4aa8c8/f468bfbd6383d0df",
//      ]
//      "http_tcp_listener_ids" = [
//        "arn:aws:elasticloadbalancing:us-east-1:485146132295:listener/app/jntest-mke/8208e898cb4aa8c8/f468bfbd6383d0df",
//      ]
//      "https_listener_arns" = []
//      "https_listener_ids" = []
//      "lb_arn" = "arn:aws:elasticloadbalancing:us-east-1:485146132295:loadbalancer/app/jntest-mke/8208e898cb4aa8c8"
//      "lb_arn_suffix" = "app/jntest-mke/8208e898cb4aa8c8"
//      "lb_dns_name" = "jntest-mke-310358209.us-east-1.elb.amazonaws.com"
//      "lb_id" = "arn:aws:elasticloadbalancing:us-east-1:485146132295:loadbalancer/app/jntest-mke/8208e898cb4aa8c8"
//      "lb_zone_id" = "Z35SXDOTRQ7X7K"
//      "security_group_arn" = "arn:aws:ec2:us-east-1:485146132295:security-group/sg-02ccb6569aacde85d"
//      "security_group_id" = "sg-02ccb6569aacde85d"
//      "target_group_arn_suffixes" = [
//        "targetgroup/tf-20230915100913756900000004/ba4b3d90cdc81c79",
//      ]
//      "target_group_arns" = [
//        "arn:aws:elasticloadbalancing:us-east-1:485146132295:targetgroup/tf-20230915100913756900000004/ba4b3d90cdc81c79",
//      ]
//      "target_group_attachments" = {
//        "0.i-0865b20ceb6faddfe" = "arn:aws:elasticloadbalancing:us-east-1:485146132295:targetgroup/tf-20230915100913756900000004/ba4b3d90cdc81c79-20230915101513551800000002"
//        "0.i-0869e0688d5794c41" = "arn:aws:elasticloadbalancing:us-east-1:485146132295:targetgroup/tf-20230915100913756900000004/ba4b3d90cdc81c79-20230915101513546100000001"
//        "0.i-0cddcd6d9e7abb988" = "arn:aws:elasticloadbalancing:us-east-1:485146132295:targetgroup/tf-20230915100913756900000004/ba4b3d90cdc81c79-20230915120023552800000001"
//      }
//      "target_group_names" = [
//        "tf-20230915100913756900000004",
//      ]
//    }
//

//           "node" = {
//                  - ami                         = "ami-0c38efb4f5f15205f"
//                  - arn                         = "arn:aws:ec2:us-east-1:485146132295:instance/i-0ce08f32ee61c1cd0"
//                  - associate_public_ip_address = false
//                  - availability_zone           = "us-east-1c"
//                  - credit_specification        = []
//                  - disable_api_stop            = false
//                  - disable_api_termination     = false
//                  - ebs_block_device            = [
//                      - {
//                          - delete_on_termination = true
//                          - device_name           = "/dev/xvda"
//                          - encrypted             = false
//                          - iops                  = 3000
//                          - kms_key_id            = ""
//                          - snapshot_id           = ""
//                          - tags                  = {
//                              - expire = "2023-09-18T10:25:51Z"
//                              - role   = "mg-volume"
//                              - stack  = "jntest"
//                              - unit   = "AWrk"
//                            }
//                          - throughput            = 125
//                          - volume_id             = "vol-091de9201b73e22fb"
//                          - volume_size           = 100
//                          - volume_type           = "gp3"
//                        },
//                    ]
//                  - ebs_optimized               = true
//                  - enclave_options             = [
//                      - {
//                          - enabled = false
//                        },
//                    ]
//                  - ephemeral_block_device      = []
//                  - filter                      = null
//                  - get_password_data           = false
//                  - get_user_data               = false
//                  - host_id                     = ""
//                  - host_resource_group_arn     = ""
//                  - iam_instance_profile        = ""
//                  - id                          = "i-0ce08f32ee61c1cd0"
//                  - instance_id                 = "i-0ce08f32ee61c1cd0"
//                  - instance_state              = "running"
//                  - instance_tags               = null
//                  - instance_type               = "m5.xlarge"
//                  - ipv6_addresses              = []
//                  - key_name                    = ""
//                  - maintenance_options         = [
//                      - {
//                          - auto_recovery = "default"
//                        },
//                    ]
//                  - metadata_options            = [
//                      - {
//                          - http_endpoint               = "enabled"
//                          - http_protocol_ipv6          = "disabled"
//                          - http_put_response_hop_limit = 1
//                          - http_tokens                 = "optional"
//                          - instance_metadata_tags      = "disabled"
//                        },
//                    ]
//                  - monitoring                  = true
//                  - network_interface_id        = "eni-0131a929401c6bbf4"
//                  - outpost_arn                 = ""
//                  - password_data               = null
//                  - placement_group             = ""
//                  - placement_partition_number  = 0
//                  - private_dns                 = "ip-172-31-39-115.ec2.internal"
//                  - private_dns_name_options    = [
//                      - {
//                          - enable_resource_name_dns_a_record    = false
//                          - enable_resource_name_dns_aaaa_record = false
//                          - hostname_type                        = "ip-name"
//                        },
//                    ]
//                  - private_ip                  = "172.31.39.115"
//                  - public_dns                  = ""
//                  - public_ip                   = ""
//                  - root_block_device           = [
//                      - {
//                          - delete_on_termination = true
//                          - device_name           = "/dev/sda1"
//                          - encrypted             = false
//                          - iops                  = 100
//                          - kms_key_id            = ""
//                          - tags                  = {
//                              - expire = "2023-09-18T10:25:51Z"
//                              - role   = "mg-volume"
//                              - stack  = "jntest"
//                              - unit   = "AWrk"
//                            }
//                          - throughput            = 0
//                          - volume_id             = "vol-0142f36e6af3d9939"
//                          - volume_size           = 8
//                          - volume_type           = "gp2"
//                        },
//                    ]
//                  - secondary_private_ips       = []
//                  - security_groups             = []
//                  - source_dest_check           = true
//                  - subnet_id                   = "subnet-07ef4a50cd3c46699"
//                  - tags                        = {
//                      - Name   = "AWrk"
//                      - expire = "2023-09-18T10:25:51Z"
//                      - role   = "mg"
//                      - stack  = "jntest"
//                      - unit   = "AWrk"
//                    }
//                  - tenancy                     = "default"
//                  - timeouts                    = null
//                  - user_data                   = null
//                  - user_data_base64            = null
//                  - vpc_security_group_ids      = [
//                      - "sg-08621b687c903342e",
//                    ]
//                },
//
