output "networks" {
  value = libvirt_network.networks
}

output "vms" {
  value = libvirt_domain.vms
}
