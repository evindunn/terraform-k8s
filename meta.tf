terraform {
  required_version = ">= 0.15"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.6.11"
    }
    tls = {
      source = "hashicorp/tls"
      version = ">= 3.1.0"
    }
    local = {
      source = "hashicorp/local"
      version = ">= 2.1.0"
    }
    null = {
      source = "hashicorp/null"
      version = ">= 3.1.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://proliant/system"
}

provider "tls" {}
provider "local" {}

