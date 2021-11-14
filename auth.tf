resource "tls_private_key" "ceph_key_pair" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# resource "null_resource" ceph_key_provisioner {
#   connection {
#     host  = "ceph0"
#     type  = "ssh"
#     user  = "debian"
#     private_key = file(element(split(".", var.ssh_key_public), 0))
#   }

#   provisioner "file" {
#     content     = tls_private_key.ceph_key_pair.private_key_pem
#     destination = "/home/debian/.ssh/id_ed25519"
#   }  
# }

