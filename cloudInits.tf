resource "libvirt_cloudinit_disk" "cloud_inits" {
  for_each          = local.domains
  name              = "cloud_init_${each.key}.iso"
  pool              = libvirt_pool.disk_pool.name
  network_config    = file("${path.module}/files/network.cfg")
  user_data         = templatefile(
    "${path.module}/templates/cloud_init.cfg",
    {
      hostname          = each.key
      ssh_key           = each.value.sshPublicKey
      ansible_playbook  = lookup(each.value, "ansiblePlaybook", null)
      extra_files       = lookup(each.value, "extraFiles", [])
    }
  )
}