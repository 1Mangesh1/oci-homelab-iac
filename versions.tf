terraform {
  required_version = ">= 1.12.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 7.0.0"
    }
  }

  backend "oci" {
    bucket              = "tfstate-homelab"
    namespace           = "bmjhuibtkfh0"
    key                 = "homelab/terraform.tfstate"
    config_file_profile = "DEFAULT"
  }
}
