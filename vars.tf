variable ssh_key_public {
  type          = string
  description   = "The path to a public key to use for accessing the VMs"
  default       = "~/.ssh/terraform_rsa.pub"
}

locals {
  yaml_config     = yamldecode(file("${path.module}/infra.yml"))
  networks        = local.yaml_config.networks
  storagePoolName = local.yaml_config.storagePool
  domains         = local.yaml_config.domains
}