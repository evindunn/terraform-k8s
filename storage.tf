resource "libvirt_pool" "disk_pool" {
  name = local.storagePoolName
  type = "dir"
  path = "/var/lib/libvirt/images/${local.storagePoolName}"
}

resource "libvirt_volume" "base_images" {
  for_each  = toset([for hostname, domain in local.domains : domain.baseImage])
  name      = element(split("/", each.value), length(split("/", each.value)) - 1)
  pool      = libvirt_pool.disk_pool.name
  source    = each.value
  format    = "qcow2"
}


resource "libvirt_volume" "os_volumes" {
  for_each        = local.domains
  base_volume_id  = lookup(libvirt_volume.base_images, each.value.baseImage, null).id
  name            = "${each.key}.qcow2"
  pool            = libvirt_pool.disk_pool.name
  format          = "qcow2"
  size            = each.value.osDiskSize
}

locals {
    data_volumes = flatten([
        for hostname, domain in local.domains : [
            [
                for idx in range(lookup(domain, "dataVolumes", null) != null ? domain.dataVolumes.count : 0) : {
                    hostname = hostname
                    index    = idx
                    size     = domain.dataVolumes.size
                }
            ]
        ]
    ])
}

resource "libvirt_volume" "data_volumes" {
  count           = length(local.data_volumes)
  name            = "${local.data_volumes[count.index].hostname}_data${local.data_volumes[count.index].index}.qcow2"
  pool            = libvirt_pool.disk_pool.name
  format          = "raw"
  size            = local.data_volumes[count.index].size
}