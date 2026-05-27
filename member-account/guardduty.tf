# -------------------------------------------------------
# GuardDuty Configuration — Member Account
# Account: 664858858896
# -------------------------------------------------------

resource "aws_guardduty_detector" "member" {
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
    Name        = "guardduty-member-account"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "multi-account-security-lab"
  }
}

output "guardduty_detector_id" {
  description = "GuardDuty Detector ID in member account"
  value       = aws_guardduty_detector.member.id
}