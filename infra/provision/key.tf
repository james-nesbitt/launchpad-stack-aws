
resource "tls_private_key" "common_tls_ed25519" {
  algorithm = "ED25519"
}

resource "tls_private_key" "common_tls_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  # choose between ED25519 and RSA
  common_ssh_key = (
    var.ssh_algorithm == "ed25519" ?
    tls_private_key.common_tls_ed25519 :
    tls_private_key.common_tls_rsa
    )
  common_ssh_key_filename = (
    var.ssh_algorithm == "ed25519" ?
    "key_ed25519.key" :
    "key_rsa.key"
    )

}

resource "local_file" "common_ssh_public_key" {
  content  = local.common_ssh_key.private_key_openssh
  filename = "${var.key_path}/${local.common_ssh_key_filename}"
  
  provisioner "local-exec" {
    command = "chmod 0600 ${local_file.common_ssh_public_key.filename}"
  }
}

resource "aws_key_pair" "common" {
  key_name   = var.name
  public_key = local.common_ssh_key.public_key_openssh

  tags = merge({
    stack = var.name
    role = "sshkey"
  }, var.tags)
}
