output "a1_cp_public_ip" {
  value       = oci_core_instance.a1_cp.public_ip
  description = "Public IP of the a1-cp node"
}

output "a1_cp_private_ip" {
  value       = oci_core_instance.a1_cp.private_ip
  description = "Private IP of the a1-cp node"
}

output "a1_cp_id" {
  value       = oci_core_instance.a1_cp.id
  description = "OCID of the a1-cp instance"
}
