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

module "compute" {
  source              = "./modules/compute"
  compartment_ocid    = var.compartment_ocid
  subnet_id           = module.network.public_subnet_id
  ssh_public_key      = var.ssh_public_key
  ssh_nsg_id          = module.security.ssh_nsg_id
  availability_domain = var.availability_domain
}