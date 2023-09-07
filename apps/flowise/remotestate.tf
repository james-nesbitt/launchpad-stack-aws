
data "terraform_remote_state" "infra_mke" {
  backend = "local"

  config = {
    path = "../../infra/terraform.tfstate"
  }
}

locals {
  mke_url = "https://${data.terraform_remote_state.infra_mke.outputs.mke_lb}"
}
