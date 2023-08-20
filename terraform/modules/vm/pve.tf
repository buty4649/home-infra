resource "proxmox_vm_qemu" "this" {
  name        = var.name
  target_node = var.target_node

  automatic_reboot = true
  bios             = "ovmf"
  boot             = "order=net0;scsi0"
  cores            = 4
  cpu              = "host"
  full_clone       = false
  kvm              = true
  memory           = var.memory
  onboot           = true
  oncreate         = false
  pxe              = true
  qemu_os          = "l26"
  scsihw           = "virtio-scsi-single"
  sockets          = 1

  disk {
    backup   = true
    format   = "qcow2"
    iothread = 1
    size     = var.disk_size
    ssd      = 1
    storage  = "local"
    type     = "scsi"
  }

  network {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
  }
}
