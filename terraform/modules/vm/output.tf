output "name" {
  value = var.name
}

output "pve_id" {
  value = proxmox_vm_qemu.this.id
}

output "maas_id" {
  value = maas_machine.this.id
}
