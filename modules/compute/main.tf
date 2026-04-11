# ---------- Look up the latest Ubuntu 22.04 ARM image ----------
# We let OCI tell us the current image OCID instead of hardcoding it,
# so the module doesn't go stale when Canonical publishes updates.
data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  state                    = "AVAILABLE"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# ---------- a1-cp: ARM control plane node ----------
resource "oci_core_instance" "a1_cp" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "a1-cp"
  shape               = "VM.Standard.A1.Flex"

  # HARDCODED to free-tier limits. Do not flex these up.
  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_arm.images[0].id
    boot_volume_size_in_gbs = 50 # well under 200GB total free quota
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    nsg_ids          = [var.ssh_nsg_id]
    hostname_label   = "a1-cp"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("${path.module}/cloud-init/a1-cp.yaml"))
  }

  # Don't recreate the instance if Canonical publishes a new image.
  # We'll handle OS upgrades in-place via apt, not by destroying the box.
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }
}
