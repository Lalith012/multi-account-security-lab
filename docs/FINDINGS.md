\# Security Findings \& Engineering Lessons



\## Overview



This document captures real issues encountered during deployment, root causes,

and resolutions. These findings demonstrate real-world complexity of enterprise

cloud security architecture.



\---



\## Finding 1 — SCP Lockout: Root Account Blocked from Member Account



\*\*Phase:\*\* 5 — Security Baseline Automation

\*\*Severity:\*\* High (operational blocker)



\*\*What happened:\*\*

After deploying `DenyRootAccountUsage` SCP on the Workloads OU, the root user

of the member account was blocked from performing IAM operations including

`iam:ListUsers` and `iam:AttachUserPolicy`. This created a catch-22 — the IAM

user lacked permissions to fix itself, and root was blocked by the SCP.



\*\*Root cause:\*\*

SCPs apply to all principals in member accounts including root. The SCP was

correctly designed but deployed before ensuring the IAM user had sufficient

permissions.



\*\*Resolution:\*\*

1\. Temporarily detached `DenyRootAccountUsage` SCP from Workloads OU via

&#x20;  AWS Organizations console in management account

2\. Logged into member account as root

3\. Attached `AdministratorAccess` to the IAM user

4\. Reattached SCP via `terraform apply` from management account



\*\*Lesson:\*\*

Always ensure IAM users have sufficient permissions before enforcing root

denial SCPs. In production, a break-glass procedure must be documented before

deploying root lockout policies. The management account is always exempt from

SCPs and can be used to remediate.



\---



\## Finding 2 — Over-Broad SCP Blocking Legitimate Terraform Operations



\*\*Phase:\*\* 5 — Security Baseline Automation

\*\*Severity:\*\* Medium



\*\*What happened:\*\*

`DenyDisableSecurityServices` SCP included `guardduty:UpdateDetector` in its

deny list. When Terraform attempted to update the GuardDuty detector

configuration (adding tags, disabling Kubernetes audit logs), the operation

was blocked with `AccessDeniedException`.



\*\*Root cause:\*\*

`guardduty:UpdateDetector` was incorrectly included in the deny list. The

intent was to prevent disabling GuardDuty, not to block all configuration

updates.



\*\*Resolution:\*\*

Removed `guardduty:UpdateDetector` from the SCP deny list, keeping only

destructive actions: `guardduty:DeleteDetector`, `guardduty:DisassociateFromMasterAccount`,

`guardduty:StopMonitoringMembers`.



\*\*Lesson:\*\*

SCPs should deny the minimum set of actions required. Over-broad denies

block legitimate operations. Always test SCPs in a sandbox OU before

applying to production workloads.



\---



\## Finding 3 — Existing Resources Require Terraform Import



\*\*Phase:\*\* 5 — Security Baseline Automation

\*\*Severity:\*\* Low



\*\*What happened:\*\*

GuardDuty and Security Hub already existed in the member account from a

previous project. Terraform attempted to create new resources and received

`BadRequestException: detector already exists` and

`ResourceConflictException: Account is already subscribed to Security Hub`.



\*\*Root cause:\*\*

Terraform state had no knowledge of pre-existing resources. Without import,

Terraform always attempts to create rather than manage existing resources.



\*\*Resolution:\*\*

Used `terraform import` to bring existing resources under Terraform management:

\- `terraform import aws\_guardduty\_detector.member f8cf1ff1835c1137f850dda85d39f774`

\- `terraform import aws\_securityhub\_account.member 664858858896`



\*\*Lesson:\*\*

In brownfield environments (accounts with existing resources), always audit

what exists before writing Terraform. Use `terraform import` to bring existing

resources under IaC management rather than destroying and recreating.



\---



\## Finding 4 — Unicode Character Rejected by AWS SSO API



\*\*Phase:\*\* 4 — IAM Identity Center

\*\*Severity:\*\* Low



\*\*What happened:\*\*

Terraform apply failed with `ValidationException: Member must satisfy regular

expression pattern` when creating a Security Hub permission set. The description

field contained an em dash (—) character.



\*\*Root cause:\*\*

AWS SSO API only accepts ASCII characters (0x09, 0x0A, 0x0D, 0x20-0x7E,

0xA1-0xFF) in description fields. The em dash (U+2014) is outside this range.



\*\*Resolution:\*\*

Replaced em dash with a standard hyphen (-) in the description field.



\*\*Lesson:\*\*

When writing Terraform for AWS SSO/IAM Identity Center, use only standard

ASCII characters in all string fields. This applies to names, descriptions,

and tags.



\---



\## Finding 5 — Security Hub enable\_default\_standards Conflict



\*\*Phase:\*\* 5 — Security Baseline Automation

\*\*Severity:\*\* Medium



\*\*What happened:\*\*

After importing the existing Security Hub account into Terraform state,

`terraform plan` showed a destroy-and-recreate operation because

`enable\_default\_standards` in the existing resource was `false` but the

Terraform config had it set to `true`. Terraform attempted to disable and

re-enable Security Hub, which was blocked by the `DenyDisableSecurityServices`

SCP.



\*\*Root cause:\*\*

The imported resource state didn't match the Terraform configuration. The

`enable\_default\_standards = true` flag forces replacement, not an in-place

update.



\*\*Resolution:\*\*

Set `enable\_default\_standards = false` in the Terraform config to match the

existing resource state. Standards are managed separately via

`aws\_securityhub\_standards\_subscription` resources.



\*\*Lesson:\*\*

When importing existing resources, always run `terraform plan` immediately

after import and reconcile any configuration differences before applying.

Never apply a plan that shows destroy-and-recreate on security services

without understanding the full impact.

