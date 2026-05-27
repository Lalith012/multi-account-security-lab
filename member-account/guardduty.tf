# -------------------------------------------------------
# GuardDuty Configuration — Member Account
# Account: 664858858896
# Note: Datasource settings managed by delegated admin
# (management account 986151953551)
# -------------------------------------------------------

resource "aws_guardduty_detector" "member" {
  enable = true

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