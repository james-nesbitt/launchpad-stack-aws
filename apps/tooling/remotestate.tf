data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../../infra/terraform.tfstate"
  }
}

locals {
  nodegroups = data.terraform_remote_state.infra.outputs.nodes
  ingresses  = data.terraform_remote_state.infra.outputs.ingresses

  launchpad_yaml = data.terraform_remote_state.infra.outputs.launchpad_yaml
}
