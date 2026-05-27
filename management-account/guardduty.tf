# -------------------------------------------------------
# GuardDuty — Management Account
# Delegated Administrator for the Organization
# Account: 986151953551
# -------------------------------------------------------

resource "aws_guardduty_detector" "management" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = false
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }

  tags = {
    Name        = "guardduty-management-account"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "multi-account-security-lab"
  }
}

# Designate management account as GuardDuty delegated admin
resource "aws_guardduty_organization_admin_account" "management" {
  admin_account_id = var.management_account_id
  depends_on       = [aws_guardduty_detector.management]
}

# Auto-enable GuardDuty for all new member accounts
resource "aws_guardduty_organization_configuration" "main" {
  auto_enable_organization_members = "ALL"
  detector_id                      = aws_guardduty_detector.management.id
  depends_on                       = [aws_guardduty_organization_admin_account.management]
}

output "guardduty_management_detector_id" {
  description = "GuardDuty Detector ID in management account"
  value       = aws_guardduty_detector.management.id
}