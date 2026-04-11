variable "compartment_ocid" {
  type        = string
  description = "Compartment for compute instances"
}

variable "subnet_id" {
  type        = string
  description = "Subnet to launch instances in"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for instance access"
}

variable "ssh_nsg_id" {
  type        = string
  description = "NSG OCID for SSH access"
}

variable "availability_domain" {
  type        = string
  description = "AD to launch in (e.g. 'xxxx:AP-MUMBAI-1-AD-1')"
}
