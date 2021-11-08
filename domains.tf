module "ceph_domains" {
  source            = "github.com/evindunn/terraform-kvm-module"
  hostname_prefix   = "ceph"
  ssh_public_key    = file(local_file.ssh_key_public.filename)
  node_count        = 3
  network_id        = libvirt_network.bridge.id
  ansible_playbook  = templatefile(
    "${path.module}/files/ansible-ceph-prepare.yml",
    {
      ceph_public_key = tls_private_key.ceph_key_pair.public_key_openssh
    }
  )
  extra_files       = [
    {
      hostname      = "ceph0"
      path          = "/var/opt/id_ed25519"
      owner         = "debian:debian"
      permissions   = "0600"
      content       = tls_private_key.ceph_key_pair.private_key_pem
    }
  ]
  mac_addresses     = [
    "54:52:00:00:01:00",
    "54:52:00:00:01:01",
    "54:52:00:00:01:02",
  ]
  data_volumes      = {
    count = 3
    size  = 5369000000 # 5GiB
  }
}

module "k8s_domains" {
  source            = "github.com/evindunn/terraform-kvm-module"
  hostname_prefix   = "k8s"
  ssh_public_key    = file(local_file.ssh_key_public.filename)
  node_count        = 3
  ansible_playbook  = file("${path.module}/files/ansible-k8s-prepare.yml")
  network_id        = libvirt_network.bridge.id
  os_disk_size      = 34360000000 # 32 GiB
  mac_addresses     = [
    "54:52:00:00:02:00",
    "54:52:00:00:02:01",
    "54:52:00:00:02:02",
  ]
}

