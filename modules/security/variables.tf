variable "compartment_ocid" {
  type        = string
  description = "Compartment for security resources"
}

variable "vcn_id" {
  type        = string
  description = "VCN to attach NSGs to"
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "CIDR allowed to SSH. Use your home IP/32 for tighter security, or 0.0.0.0/0 for open."
  default     = "0.0.0.0/0"
}

variable "wireguard_port" {
  type        = number
  description = "UDP port for WireGuard"
  default     = 51820
}
