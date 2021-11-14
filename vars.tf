locals {
  yaml_config     = yamldecode(file("${path.module}/infra.yml"))
  networks        = local.yaml_config.networks
  storagePoolName = local.yaml_config.storagePool
  domains         = local.yaml_config.domains
}