resource "libvirt_network" "bridge" {
  name        = "bridge"
  mode        = "bridge"
  bridge      = "br0"
  autostart   = true

  dhcp {
    enabled = false
  }

  dns {
    enabled = false
  }
}

