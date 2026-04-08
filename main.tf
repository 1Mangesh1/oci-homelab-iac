module "network" {
  source           = "./modules/network"
  compartment_ocid = var.compartment_ocid
}