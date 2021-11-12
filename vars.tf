variable ssh_key_public {
  type          = string
  description   = "The path to a public key to use for accessing the VMs"
  default       = "~/.ssh/terraform_rsa.pub"
}
