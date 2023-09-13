data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../../infra/terraform.tfstate"
  }
}

locals {
  mke_connect = data.terraform_remote_state.infra.outputs.mke_connect
}
