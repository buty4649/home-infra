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
