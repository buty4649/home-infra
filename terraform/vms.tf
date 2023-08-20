terraform {
  backend "s3" {
    bucket = "buty4649-home-infra"
    region = "ap-northeast-1"
    key    = "terraform"
  }
}

locals {
  vms = {
    cluster-api       = {},
    k8s-control-plane = {},
    k8s-worker-1 = {
      disk_size = "256G",
      memory    = 16384,
    },
    k8s-worker-2 = {
      disk_size = "256G",
      memory    = 16384,
    },
  }
  target_node = "miyakojima"
}

module "vm" {
  source = "./modules/vm"

  for_each = local.vms

  name        = each.key
  domain      = "b-net.local"
  target_node = local.target_node

  memory    = lookup(each.value, "memory", 8192)
  disk_size = lookup(each.value, "disk_size", "72G")

  pve_host             = var.pve_host
  pve_user             = var.pve_user
  pve_api_token_name   = var.pve_api_token_name
  pve_api_token_secret = var.pve_api_token_secret
  pve_verify_ssl       = !var.pve_tls_insecure
}

output "vms" {
  value = [
    for vm in module.vm : { "${vm.name}" = {
      pve_id  = vm.pve_id
      maas_id = vm.maas_id
    } }
  ]
}
