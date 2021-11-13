resource "libvirt_pool" "disk_pool" {
  name = local.storagePoolName
  type = "dir"
  path = "/var/lib/libvirt/images/${local.storagePoolName}"
}