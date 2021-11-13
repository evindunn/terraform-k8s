resource "libvirt_domain" "vms" {
  for_each  = local.domains
  autostart = true
  name      = each.key
  vcpu      = each.value.cpuCount
  memory    = each.value.ramSize
  cloudinit = libvirt_cloudinit_disk.cloud_inits[each.key].id

  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  disk {
    volume_id = libvirt_volume.os_volumes[each.key].id
    scsi      = true
  }

  dynamic "disk" {
    for_each = toset([
      for vol in libvirt_volume.data_volumes :
      vol if split("_", vol.name)[0] == each.key
    ])
    content {
      volume_id = disk.value.id
      scsi      = true
    }
  }

  dynamic "network_interface" {
    for_each = each.value.macAddresses
    content {
      hostname   = each.key
      mac        = network_interface.value.address
      network_id = libvirt_network.networks[network_interface.value.networkName].id
    }
  }
}
