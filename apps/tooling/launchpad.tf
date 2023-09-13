
resource "local_file" "launchpad_config" {
  content  = local.launchpad_yaml
  filename = "launchpad.yaml"
}
