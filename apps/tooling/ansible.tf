locals {
  ansible_inventory = <<-EOT
  %{~for ng in local.nodegroups}
  [${ng.name}]
  %{~for n in ng.nodes~}
  %{~if ng.connection == "ssh"~}
  ${n.label} ansible_connection=ssh ansible_ssh_private_key_file=${n.key_path_abs} ansible_user=${ng.ssh_user} ansible_host=${n.public_address}
  %{~endif~}
  %{~endfor}
  %{~endfor~}
  EOT
}

output "ansible_inventory" {
  description = "ansible inventory file"
  value       = local.ansible_inventory
}

# Create Ansible inventory file
resource "local_file" "ansible_inventory" {
  content  = local.ansible_inventory
  filename = "hosts.ini"
}
