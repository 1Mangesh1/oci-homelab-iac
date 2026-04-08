output "ssh_nsg_id" {
  value       = oci_core_network_security_group.ssh.id
  description = "OCID of the SSH NSG"
}

output "web_nsg_id" {
  value       = oci_core_network_security_group.web.id
  description = "OCID of the web (HTTP/HTTPS) NSG"
}

output "wireguard_nsg_id" {
  value       = oci_core_network_security_group.wireguard.id
  description = "OCID of the WireGuard NSG"
}
