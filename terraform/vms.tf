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
  domain      = "b-net.local"
  target_node = local.target_node

  pve_host             = var.pve_host
  pve_user             = var.pve_user
  pve_api_token_name   = var.pve_api_token_name
  pve_api_token_secret = var.pve_api_token_secret
  pve_verify_ssl       = !var.pve_tls_insecure
}
