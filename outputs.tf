output "private_key" {
  value = local_file.ssh_key_private.filename
}

output "public_key" {
  value = local_file.ssh_key_public.filename
}

output "ceph_vms" {
  value = module.ceph_domains.vms
}

output "k8s_vms" {
  value = module.k8s_domains.vms
}

