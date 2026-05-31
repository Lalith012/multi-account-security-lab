<div align="center">

# 🏗️ Multi-Account AWS Security Architecture

### Enterprise-Grade Cloud Security Governance with Terraform IaC

[![AWS](https://img.shields.io/badge/AWS-Organizations-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)](https://aws.amazon.com/organizations/)
[![Terraform](https://img.shields.io/badge/Terraform-v1.15.4-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![Security](https://img.shields.io/badge/GuardDuty-Enabled-00A86B?style=for-the-badge&logo=amazonaws&logoColor=white)](https://aws.amazon.com/guardduty/)
[![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)](https://github.com/Lalith012/multi-account-security-lab)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

*Architecting and enforcing security controls across multiple AWS accounts from a single management plane — the way enterprise cloud security actually works.*

</div>

---

## 📌 Overview

This project implements a production-grade multi-account AWS security architecture using **Terraform Infrastructure as Code**. It demonstrates governance at scale — enforcing security controls across AWS accounts from a central management account using AWS Organizations, Service Control Policies, IAM Identity Center, and delegated security monitoring.

> **Why this matters:** Most AWS security projects operate in a single account. Real enterprises run dozens or hundreds of accounts. This project bridges that gap.

---

## 🏛️ Architecture

---

```
┌─────────────────────────────────────────────────────────────┐
│                    AWS Organizations                         │
│                   Root (r-9gja)                             │
│                                                             │
│  ┌─────────────────────────────────┐                        │
│  │   Management Account            │                        │
│  │   986151953551                  │                        │
│  │   ┌─────────────────────────┐   │                        │
│  │   │ • AWS Organizations     │   │                        │
│  │   │ • Service Control Policies   │                        │
│  │   │ • IAM Identity Center   │   │                        │
│  │   │ • GuardDuty Admin       │   │                        │
│  │   │ • Security Hub Admin    │   │                        │
│  │   └─────────────────────────┘   │                        │
│  └─────────────────────────────────┘                        │
│                    │ SCPs enforced ▼                         │
│  ┌─────────────────────────────────┐                        │
│  │   Workloads OU                  │                        │
│  │   ┌─────────────────────────┐   │                        │
│  │   │   Member Account        │   │                        │
│  │   │   664858858896          │   │                        │
│  │   │ • GuardDuty             │   │                        │
│  │   │ • CloudTrail            │   │                        │
│  │   │ • Security Hub          │   │                        │
│  │   └─────────────────────────┘   │                        │
│  └─────────────────────────────────┘                        │
└─────────────────────────────────────────────────────────────┘

```

---

## ⚙️ What This Project Demonstrates

| Capability | Implementation |
|---|---|
| **Multi-Account Governance** | AWS Organizations with Root, Workloads, Security, Sandbox OUs |
| **Permission Guardrails** | 3 SCPs: Region Lock, Root Denial, Security Service Protection |
| **Centralized SSO** | IAM Identity Center with SecurityAdmin and ReadOnly permission sets |
| **Threat Detection** | GuardDuty org-level with delegated admin and auto-enrollment |
| **Audit Logging** | CloudTrail multi-region trail with S3 data events and log validation |
| **Compliance Monitoring** | Security Hub with CIS v1.4.0 and AWS Foundational Best Practices |
| **IaC at Scale** | Terraform with S3 remote state backend and DynamoDB locking |
| **Cross-Account Visibility** | Centralized findings aggregation in management account |

---

## 🛡️ Service Control Policies

Three SCPs enforced on the Workloads OU — applied to every account in the OU automatically:

| SCP | Policy ID | Purpose |
|---|---|---|
| ✅ DenyNonMumbaiRegions | p-m620jcgl | Restricts all actions to ap-south-1 |
| ✅ DenyRootAccountUsage | p-g4mnytx3 | Blocks all root user actions in member accounts |
| ✅ DenyDisableSecurityServices | p-u97j4xop | Prevents deletion of GuardDuty, CloudTrail, Security Hub |

> SCPs cannot be overridden by anyone in the member account — not even the account's own root user.

---

## 📁 Repository Structure

---

```

multi-account-security-lab/
├── management-account/         # Terraform for Organizations, SCPs, IAM Identity Center
│   ├── main.tf                 # Provider config + S3 remote backend
│   ├── variables.tf            # Account IDs, region, environment
│   ├── organizations.tf        # AWS Organizations + OUs
│   ├── scps.tf                 # Service Control Policies
│   ├── identity-center.tf      # IAM Identity Center permission sets
│   ├── guardduty.tf            # GuardDuty delegated admin + org config
│   └── securityhub.tf          # Security Hub delegated admin + org config
├── member-account/             # Terraform for security baseline
│   ├── main.tf                 # Provider config + remote state
│   ├── variables.tf            # Account IDs, region, bucket names
│   ├── guardduty.tf            # GuardDuty detector
│   ├── cloudtrail.tf           # CloudTrail trail + S3 bucket
│   └── securityhub.tf          # Security Hub + CIS + AWS FSBP standards
├── modules/                    # Reusable Terraform modules (next iteration)
│   ├── guardduty/
│   ├── cloudtrail/
│   ├── securityhub/
│   └── iam/
├── docs/
│   ├── ARCHITECTURE.md         # Full architecture reference
│   └── FINDINGS.md             # Engineering findings and lessons learned
└── DISCLAIMER.md

```
---

---

## 🔧 Tech Stack

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=flat-square&logo=amazonaws&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white)

| Tool | Version | Purpose |
|---|---|---|
| Terraform | v1.15.4 | Infrastructure as Code |
| AWS Provider | v5.100.0 | Terraform AWS integration |
| AWS Organizations | — | Multi-account governance |
| GuardDuty | Org-level | Threat detection |
| CloudTrail | Multi-region | API audit logging |
| Security Hub | CIS v1.4.0 + FSBP | Compliance monitoring |
| S3 + DynamoDB | — | Terraform remote state + locking |

---

## 🚀 Remote State Architecture

Terraform state is stored remotely in S3 with DynamoDB locking — preventing state corruption from concurrent runs:

```hcl
backend "s3" {
  bucket       = "terraform-state-986151953551"
  key          = "management-account/terraform.tfstate"
  region       = "ap-south-1"
  use_lockfile = true
  encrypt      = true
}
```

---

## 📊 Project Status

| Phase | Description | Status |
|---|---|---|
| 1 | Environment Setup + Terraform Foundation | ✅ Complete |
| 2 | AWS Organizations Setup | ✅ Complete |
| 3 | Service Control Policies | ✅ Complete |
| 4 | IAM Identity Center | ✅ Complete |
| 5 | Security Baseline Automation | ✅ Complete |
| 6 | Cross-Account Security Monitoring | ✅ Complete |
| 7 | Final Documentation and Report | ✅ Complete |

---

## 📝 Engineering Findings

Real issues encountered and resolved during deployment — documented in [`docs/FINDINGS.md`](docs/FINDINGS.md):

| Finding | Severity | Summary |
|---|---|---|
| SCP Lockout | 🔴 High | Root denial SCP blocked IAM user from granting its own permissions |
| Over-broad SCP | 🟡 Medium | guardduty:UpdateDetector incorrectly included in deny list |
| Terraform Import | 🟢 Low | Existing resources required import rather than create |
| Unicode in SSO API | 🟢 Low | Em dash character rejected by AWS SSO API |
| Security Hub Import Conflict | 🟡 Medium | enable_default_standards mismatch caused destroy-and-recreate |

---

## ⚠️ Disclaimer

This repository is built for educational and portfolio purposes only. All infrastructure is deployed in isolated personal accounts. No production data or third-party systems are involved. See [DISCLAIMER.md](DISCLAIMER.md) for full details.

---





