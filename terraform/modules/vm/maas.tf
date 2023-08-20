resource "maas_machine" "this" {
  hostname   = var.name
  domain     = var.domain
  power_type = "proxmox"
  power_parameters = {
    power_address      = var.pve_host
    power_user         = var.pve_user
    power_token_name   = var.pve_api_token_name
    power_token_secret = var.pve_api_token_secret
    # e.g. node/qemu/<id>
    power_vm_name    = split("/", proxmox_vm_qemu.this.id)[2]
    power_verify_ssl = var.pve_verify_ssl ? "y" : "n"
  }
  pxe_mac_address = proxmox_vm_qemu.this.network.0.macaddr
}
