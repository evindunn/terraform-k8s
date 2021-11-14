resource "libvirt_cloudinit_disk" "cloud_inits" {
  for_each          = local.domains
  name              = "cloud_init_${each.key}.iso"
  pool              = libvirt_pool.disk_pool.name
  network_config    = templatefile(
    "${path.module}/templates/network.cfg",
    {
      dns_servers: each.value.dns.servers,
      dns_search: each.value.dns.search
    }
  )
  user_data         = templatefile(
    "${path.module}/templates/cloud_init.cfg",
    {
      hostname          = each.key
      ssh_key           = file(pathexpand(each.value.sshPublicKey))
      ansible_playbook  = file(pathexpand(lookup(each.value, "ansiblePlaybook", null)))
      extra_files       = lookup(each.value, "extraFiles", [])
    }
  )
}

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
    for_each = each.value.networkInterfaces
    content {
      hostname   = each.key
      mac        = lookup(network_interface.value, "mac", null)
      network_id = libvirt_network.networks[network_interface.value.networkName].id
      addresses  = lookup(network_interface.value, "ip", null) == null ? [] : [network_interface.value.ip]
    }
  }
}
