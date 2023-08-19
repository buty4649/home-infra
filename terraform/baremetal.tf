terraform {
  required_providers {
    maas = {
      source  = "maas/maas"
      version = "~>1.0"
    }
  }
}

resource "maas_machine" "miyakojima" {
  hostname         = "miyakojima"
  domain           = "b-net.local"
  power_type       = "manual"
  power_parameters = {}
  pxe_mac_address  = "38:f7:cd:c4:e4:a5"
}

import {
  id = "miyakojima"
  to = maas_instance.miyakojima
}
resource "maas_instance" "miyakojima" {}

output "miyakojima" {
  value = "id: ${maas_machine.miyakojima.id} ips: ${join(", ", maas_instance.miyakojima.ip_addresses)}"
}
