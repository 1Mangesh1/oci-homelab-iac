variable "compartment_ocid" {
  type        = string
  description = "Compartment to create network resources in"
}

variable "vcn_cidr" {
  type        = string
  description = "CIDR block for the VCN"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}