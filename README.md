\# Multi-Account AWS Security Architecture



Enterprise-grade cloud security architecture using AWS Organizations, Terraform IaC,

Service Control Policies, and centralized security monitoring across multiple AWS accounts.



\## Architecture Overview



| Account | ID | Role |

|---|---|---|

| Management | 986151953551 | Governance, SCPs, Organizations root |

| Member (Security Lab) | 664858858896 | Workloads, detection lab, existing findings |



\## What This Project Demonstrates



\- Multi-account governance using AWS Organizations and Organizational Units

\- Permission guardrails enforced via Service Control Policies (SCPs)

\- Security baseline automation (GuardDuty, CloudTrail, Security Hub) via Terraform

\- Centralized logging and cross-account threat visibility

\- IAM Identity Center SSO across accounts

\- Infrastructure as Code with remote state management (S3 + DynamoDB)



\## Project Structure



multi-account-security-lab/

├── management-account/   # Terraform for Organizations, SCPs, IAM Identity Center

├── member-account/       # Terraform for security baselines in member account

├── modules/              # Reusable Terraform modules

│   ├── guardduty/

│   ├── cloudtrail/

│   ├── securityhub/

│   └── iam/

├── scripts/              # Python/PowerShell helper scripts

└── docs/                 # Architecture diagrams and reports



\## Tech Stack



Terraform · AWS Organizations · SCPs · IAM Identity Center · GuardDuty ·

CloudTrail · Security Hub · AWS Config · Python · GitHub



\## Status



| Phase | Title | Status |

|---|---|---|

| 1 | Environment Setup + Terraform Foundation | In Progress |

| 2 | AWS Organizations Setup | Planned |

| 3 | Service Control Policies | Planned |

| 4 | IAM Identity Center | Planned |

| 5 | Security Baseline Automation | Planned |

| 6 | Cross-Account Security Monitoring | Planned |

| 7 | Final Documentation and Report | Planned |



\## Disclaimer



See \[DISCLAIMER.md](DISCLAIMER.md)

