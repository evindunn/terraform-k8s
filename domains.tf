module "ceph_domains" {
  source            = "github.com/evindunn/terraform-kvm-module"
  hostname_prefix   = "ceph"
  node_count        = 3
  ansible_playbook  = "./ansible-ceph-prepare.yml"
  network_id        = libvirt_network.bridge.id
  mac_addresses     = [
    "54:52:00:00:01:00",
    "54:52:00:00:01:01",
    "54:52:00:00:01:02",
  ]
  data_volumes      = {
    count = 1
    size  = 4295000000 # 4GiB
  }
}

module "k8s_domains" {
  source            = "github.com/evindunn/terraform-kvm-module"
  hostname_prefix   = "k8s"
  node_count        = 3
  ansible_playbook  = "./ansible-k8s-prepare.yml"
  network_id        = libvirt_network.bridge.id
  os_disk_size      = 34360000000 # 32 GiB
  mac_addresses     = [
    "54:52:00:00:02:00",
    "54:52:00:00:02:01",
    "54:52:00:00:02:02",
  ]
}

