# OCI Homelab IaC

Terraform infrastructure-as-code for a personal cloud platform running on Oracle Cloud Infrastructure (OCI) Always Free tier. Designed to host a multi-node k3s cluster for running side projects, learning Kubernetes, and building portfolio-grade infrastructure skills.

## Architecture

**Target state:** 4 instances using 100% of the Always Free compute quota.

| Instance | Shape | OCPU | RAM | Role |
|----------|-------|------|-----|------|
| `a1-cp` | VM.Standard.A1.Flex | 2 | 12 GB | k3s control plane (Traefik, cert-manager, monitoring) |
| `a1-worker` | VM.Standard.A1.Flex | 2 | 12 GB | k3s worker (application workloads) |
| `e2-bastion` | VM.Standard.E2.1.Micro | 1 | 1 GB | WireGuard VPN + SSH bastion |
| `e2-monitor` | VM.Standard.E2.1.Micro | 1 | 1 GB | External uptime monitoring |

**Free tier totals:** 4 OCPU / 24 GB ARM + 2 AMD micros, 200 GB block storage, 10 TB egress/month.

### Network

- VCN `10.0.0.0/16` with a public subnet `10.0.1.0/24`
- Internet gateway + route table for outbound traffic
- NSGs for SSH, HTTP/HTTPS, and WireGuard (UDP 51820)

### Security

- SSH hardened via cloud-init (password auth disabled, root login disabled)
- fail2ban on all instances
- UFW firewall enabled on boot
- WireGuard bastion pattern: k3s nodes accessed via VPN, not direct SSH (planned)

## Modules

```
modules/
  network/    # VCN, subnet, IGW, route table
  security/   # NSGs for SSH, web, WireGuard
  compute/    # Instance definitions + cloud-init
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.12.0
- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) configured with API key auth
- An OCI Always Free tenancy with a compartment created
- An OCI Object Storage bucket for remote state (`tfstate-homelab`)

## Quick start

```bash
# 1. Clone and configure
git clone <this-repo>
cd oci-homelab-iac
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your OCI credentials and OCIDs

# 2. Look up your availability domain
oci iam availability-domain list \
  --compartment-id <your-compartment-ocid> \
  --query 'data[].name'
# Add the result to terraform.tfvars as availability_domain

# 3. Init, plan, apply
terraform init
terraform plan
terraform apply

# 4. Verify SSH access (~2 min after apply for cloud-init)
ssh ubuntu@$(terraform output -raw a1_cp_public_ip)
cat /var/log/cloud-init-done.log
```

## Staged rollout

Instances are added incrementally, not all at once:

1. `a1-cp` -- ARM control plane node (current)
2. `a1-worker` -- ARM worker node
3. `e2-bastion` -- WireGuard + SSH bastion
4. `e2-monitor` -- External uptime monitor

## ARM capacity note

ARM A1 instances in popular regions (Mumbai) may hit `Out of host capacity` errors. This is an Oracle capacity issue, not a bug. Retry `terraform apply` periodically -- it usually succeeds within a few attempts. If it persists, temporarily reduce the shape to 1 OCPU / 6 GB and resize later.

## State backend

Terraform state is stored remotely in OCI Object Storage:

```hcl
backend "oci" {
  bucket    = "tfstate-homelab"
  namespace = "bmjhuibtkfh0"
  key       = "homelab/terraform.tfstate"
}
```

## Cost

$0. Every resource stays within OCI Always Free limits.
