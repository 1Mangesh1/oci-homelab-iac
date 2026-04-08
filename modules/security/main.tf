# ---------- SSH NSG ----------
resource "oci_core_network_security_group" "ssh" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = "homelab-nsg-ssh"
}

resource "oci_core_network_security_group_security_rule" "ssh_ingress" {
  network_security_group_id = oci_core_network_security_group.ssh.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = var.ssh_allowed_cidr
  source_type               = "CIDR_BLOCK"
  description               = "Allow SSH from trusted CIDR"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# ---------- Web NSG (HTTP + HTTPS) ----------
resource "oci_core_network_security_group" "web" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = "homelab-nsg-web"
}

resource "oci_core_network_security_group_security_rule" "http_ingress" {
  network_security_group_id = oci_core_network_security_group.web.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow HTTP from anywhere"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "https_ingress" {
  network_security_group_id = oci_core_network_security_group.web.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow HTTPS from anywhere"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

# ---------- WireGuard NSG ----------
resource "oci_core_network_security_group" "wireguard" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = "homelab-nsg-wireguard"
}

resource "oci_core_network_security_group_security_rule" "wireguard_ingress" {
  network_security_group_id = oci_core_network_security_group.wireguard.id
  direction                 = "INGRESS"
  protocol                  = "17" # UDP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow WireGuard UDP"

  udp_options {
    destination_port_range {
      min = var.wireguard_port
      max = var.wireguard_port
    }
  }
}

# ---------- Egress rule for ALL NSGs (allow all outbound) ----------
# Without this, instances can't reach package mirrors, cert renewal, etc.
resource "oci_core_network_security_group_security_rule" "ssh_egress_all" {
  network_security_group_id = oci_core_network_security_group.ssh.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Allow all egress"
}

resource "oci_core_network_security_group_security_rule" "web_egress_all" {
  network_security_group_id = oci_core_network_security_group.web.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Allow all egress"
}

resource "oci_core_network_security_group_security_rule" "wireguard_egress_all" {
  network_security_group_id = oci_core_network_security_group.wireguard.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Allow all egress"
}
