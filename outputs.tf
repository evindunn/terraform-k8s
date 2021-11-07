output "ceph_private_key" {
  value = module.ceph_domains.private_key
}

output "ceph_public_key" {
  value = module.ceph_domains.public_key
}

output "k8s_private_key" {
  value = module.k8s_domains.private_key
}

output "k8s_public_key" {
  value = module.k8s_domains.public_key
}

output "ceph_vms" {
  value = module.ceph_domains.vms
}

output "k8s_vms" {
  value = module.k8s_domains.vms
}

