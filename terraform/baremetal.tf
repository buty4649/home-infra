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
  value = {
    maas_id = maas_instance.miyakojima.id
  }
}
