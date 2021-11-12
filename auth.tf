resource "tls_private_key" "ceph_key_pair" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

