terraform {
  backend "s3" {
    bucket = "buty4649-home-infra"
    region = "ap-northeast-1"
    key    = "terraform"
  }
}

locals {
  vms         = ["cluster-api"]
  target_node = "miyakojima"
}

module "vm" {
  source = "./modules/vm"

  for_each = toset(local.vms)

  name        = each.key
  target_node = local.target_node
}
