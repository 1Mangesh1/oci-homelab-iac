module "network" {
  source           = "./modules/network"
  compartment_ocid = var.compartment_ocid
}

module "security" {
  source           = "./modules/security"
  compartment_ocid = var.compartment_ocid
  vcn_id           = module.network.vcn_id
  # ssh_allowed_cidr = "your.home.ip.address/32"  # uncomment + set to lock down SSH
}