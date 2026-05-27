# -------------------------------------------------------
# Service Control Policies (SCPs)
# Applied to Workloads OU — ou-9gja-lay9e0yi
# -------------------------------------------------------

# -------------------------------------------------------
# SCP 1: Deny actions outside ap-south-1 (Region Lock)
# -------------------------------------------------------

resource "aws_organizations_policy" "deny_non_mumbai" {
  name        = "DenyNonMumbaiRegions"
  description = "Deny all actions outside ap-south-1 except global services"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyNonMumbaiRegions"
        Effect = "Deny"
        NotAction = [
          "iam:*",
          "organizations:*",
          "route53:*",
          "budgets:*",
          "waf:*",
          "cloudfront:*",
          "sts:*",
          "support:*",
          "trustedadvisor:*"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = "ap-south-1"
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "deny_non_mumbai_workloads" {
  policy_id = aws_organizations_policy.deny_non_mumbai.id
  target_id = aws_organizations_organizational_unit.workloads.id
}

# -------------------------------------------------------
# SCP 2: Deny Root Account Usage
# -------------------------------------------------------

resource "aws_organizations_policy" "deny_root_usage" {
  name        = "DenyRootAccountUsage"
  description = "Deny all actions performed by the root user in member accounts"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyRootAccountUsage"
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          StringLike = {
            "aws:PrincipalArn" = "arn:aws:iam::*:root"
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "deny_root_usage_workloads" {
  policy_id = aws_organizations_policy.deny_root_usage.id
  target_id = aws_organizations_organizational_unit.workloads.id
}

# -------------------------------------------------------
# SCP 3: Deny Disabling Security Services
# -------------------------------------------------------

resource "aws_organizations_policy" "deny_disable_security_services" {
  name        = "DenyDisableSecurityServices"
  description = "Prevent disabling of GuardDuty, CloudTrail, and Security Hub"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
         {
  Sid    = "DenyDisableGuardDuty"
  Effect = "Deny"
  Action = [
    "guardduty:DeleteDetector",
    "guardduty:DisassociateFromMasterAccount",
    "guardduty:StopMonitoringMembers"
  ]
  Resource = "*"
},
   {
        Sid    = "DenyDisableCloudTrail"
        Effect = "Deny"
        Action = [
          "cloudtrail:DeleteTrail",
          "cloudtrail:StopLogging",
          "cloudtrail:UpdateTrail"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyDisableSecurityHub"
        Effect = "Deny"
        Action = [
          "securityhub:DeleteHub",
          "securityhub:DisableSecurityHub",
          "securityhub:DisassociateFromMasterAccount"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "deny_disable_security_workloads" {
  policy_id = aws_organizations_policy.deny_disable_security_services.id
  target_id = aws_organizations_organizational_unit.workloads.id
}

# -------------------------------------------------------
# Outputs
# -------------------------------------------------------

output "scp_deny_non_mumbai_id" {
  description = "SCP ID — Deny Non-Mumbai Regions"
  value       = aws_organizations_policy.deny_non_mumbai.id
}

output "scp_deny_root_usage_id" {
  description = "SCP ID — Deny Root Account Usage"
  value       = aws_organizations_policy.deny_root_usage.id
}

output "scp_deny_disable_security_id" {
  description = "SCP ID — Deny Disable Security Services"
  value       = aws_organizations_policy.deny_disable_security_services.id
}