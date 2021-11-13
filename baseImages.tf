resource "libvirt_volume" "base_images" {
  for_each  = toset([for hostname, domain in local.domains : domain.baseImage])
  name      = element(split("/", each.value), length(split("/", each.value)) - 1)
  pool      = libvirt_pool.disk_pool.name
  source    = each.value
  format    = "qcow2"
}
