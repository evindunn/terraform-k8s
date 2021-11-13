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

  dnsmasq_options {
    dynamic "options" {
      for_each  = lookup(each.value.dhcp, "hosts", [])
      content {
        option_name   = "dhcp-host"
        option_value  = "${options.value["mac-address"]},${options.value.ip}"
      }
    }
  }
}
