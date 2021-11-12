output "public_key" {
  value = var.ssh_key_public
}

output "ceph_vms" {
  value = module.ceph_domains.vms
}

output "k8s_vms" {
  value = module.k8s_domains.vms
}

