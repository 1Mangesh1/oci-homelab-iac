output "vcn_id" {
  value = module.network.vcn_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "ssh_nsg_id" {
  value = module.security.ssh_nsg_id
}

output "web_nsg_id" {
  value = module.security.web_nsg_id
}

output "wireguard_nsg_id" {
  value = module.security.wireguard_nsg_id
}