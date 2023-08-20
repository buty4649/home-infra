terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }

    maas = {
      source  = "maas/maas"
      version = "~>1.0"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://${var.pve_host}:8006/api2/json"
  pm_user             = var.pve_user
  pm_tls_insecure     = var.pve_tls_insecure
  pm_api_token_id     = "${var.pve_user}!${var.pve_api_token_name}"
  pm_api_token_secret = var.pve_api_token_secret
}
