\# Multi-Account AWS Security Architecture



\## Overview



This project implements enterprise-grade cloud security governance across two AWS accounts

using AWS Organizations, Terraform IaC, Service Control Policies, IAM Identity Center,

and centralized security monitoring.



\## Account Structure



| Account | ID | Role | OU |

|---|---|---|---|

| Lalith2 (Management) | 986151953551 | Governance, SCPs, Organizations root | Root |

| Lalith (Member) | 664858858896 | Workloads, security tooling | Workloads OU |



\## Organizational Structure



Root (r-9gja)

├── Management Account (986151953551) — governance only

└── Workloads OU (ou-9gja-lay9e0yi)

└── Member Account (664858858896) — workloads

Security OU (ou-9gja-rg0kdjli) — reserved for future security tooling account

Sandbox OU (ou-9gja-rtqhlkrc) — reserved for testing



\## Service Control Policies



Three SCPs enforced on the Workloads OU:



| SCP | ID | Purpose |

|---|---|---|

| DenyNonMumbaiRegions | p-m620jcgl | Restricts all actions to ap-south-1 except global services |

| DenyRootAccountUsage | p-g4mnytx3 | Blocks all actions performed by root user in member accounts |

| DenyDisableSecurityServices | p-u97j4xop | Prevents deletion or disabling of GuardDuty, CloudTrail, Security Hub |



\## IAM Identity Center



| Permission Set | Session Duration | Policy |

|---|---|---|

| SecurityAdminAccess | 8 hours | ReadOnlyAccess (expandable) |

| ReadOnlyAccess | 4 hours | ReadOnlyAccess |



Identity Store ID: d-9f67527363

SSO Instance ARN: arn:aws:sso:::instance/ssoins-6595584fe1a6a9e4



\## Security Baseline — Member Account



| Service | Configuration |

|---|---|

| GuardDuty | Enabled — S3 protection, malware protection for EC2 |

| CloudTrail | Multi-region trail, log file validation, S3 data events enabled |

| Security Hub | CIS AWS Foundations Benchmark v1.4.0, AWS Foundational Security Best Practices v1.0.0 |



\## Cross-Account Monitoring



| Service | Delegated Admin | Auto-enrollment |

|---|---|---|

| GuardDuty | 986151953551 | ALL members |

| Security Hub | 986151953551 | Enabled |



\## Remote State



| Resource | Value |

|---|---|

| S3 Bucket | terraform-state-986151953551 |

| DynamoDB Table | terraform-state-lock |

| Management state key | management-account/terraform.tfstate |

| Member state key | member-account/terraform.tfstate |



\## Tech Stack



Terraform v1.15.4 · AWS Provider v5.100.0 · AWS Organizations · SCPs ·

IAM Identity Center · GuardDuty · CloudTrail · Security Hub · S3 · DynamoDB

