resource "libvirt_network" "networks" {
  for_each    = local.networks
  name        = each.key
  mode        = each.value.mode
  bridge      = lookup(each.value, "bridge", null)
  domain      = lookup(each.value, "domain", null)
  addresses   = lookup(each.value, "addresses", [])
  autostart   = true

  dns {
    enabled = each.value.dns.enabled
    dynamic "hosts" {
      for_each  = lookup(each.value.dns, "hosts", [])
      content {
        ip       = hosts.value.ip
        hostname = hosts.value.hostname
      }
    }
  }

  dhcp {
    enabled = each.value.dhcp.enabled
  }
}
