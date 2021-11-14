output "public_key" {
  value = var.ssh_key_public
}

output "vms" {
  value = local.domains
}
