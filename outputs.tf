output "public_key" {
  value = var.ssh_key_public
}

output "data_volumes" {
  value = local.data_volumes
}

# output "ceph_vms" {
#   value = module.ceph_domains.vms
# }

# output "k8s_vms" {
#   value = module.k8s_domains.vms
# }
