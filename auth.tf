resource "tls_private_key" "ceph_key_pair" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_private_key" "ssh_key_pair" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "ssh_key_private" {
  filename        = pathexpand("~/.ssh/${local.ssh_key_prefix}")
  file_permission = "0600"
  content         = tls_private_key.ssh_key_pair.private_key_pem
}

resource "local_file" "ssh_key_public" {
  filename        = pathexpand("~/.ssh/${local.ssh_key_prefix}.pub")
  file_permission = "0644"
  content         = tls_private_key.ssh_key_pair.public_key_openssh
}

