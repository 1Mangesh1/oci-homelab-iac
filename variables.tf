variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "user_ocid" {
  type        = string
  description = "OCID of the user running Terraform"
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint of the API signing key"
}

variable "private_key_path" {
  type        = string
  description = "Path to the API signing private key"
}

variable "region" {
  type        = string
  description = "OCI region"
  default     = "ap-mumbai-1"
}

variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment to deploy resources into"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for instance access"
}