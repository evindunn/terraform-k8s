locals {
  ceph_public_key_targets = [
    for hostname, domain in local.domains :
      hostname if length(regexall("^ceph", hostname)) > 0
  ]
}

resource "tls_private_key" "ceph_key_pair" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "null_resource" ceph_private_key_provisioner {
  provisioner "file" {
    content     = tls_private_key.ceph_key_pair.private_key_pem
    destination = "/home/debian/.ssh/id_ed25519"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/debian/.ssh/id_ed25519"
    ]
  }

  connection {
    host  = "ceph0"
    type  = "ssh"
    user  = "debian"
  }

  triggers = {
    "ceph_id" = libvirt_domain.vms["ceph0"].id
  }
}

resource "null_resource" ceph_public_key_provisioner {
  for_each = toset(local.ceph_public_key_targets)

  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.ceph_key_pair.public_key_openssh}' >> ~/.ssh/authorized_keys"
    ]
  }

  connection {
    host  = each.value
    type  = "ssh"
    user  = "debian"
  }

  triggers = {
    "ceph_id" = libvirt_domain.vms[each.value].id
  }
}