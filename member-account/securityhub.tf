# -------------------------------------------------------
# Security Hub Configuration — Member Account
# Account: 664858858896
# -------------------------------------------------------

resource "aws_securityhub_account" "member" { enable_default_standards = false }

resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:ap-south-1::standards/cis-aws-foundations-benchmark/v/1.4.0"
  depends_on    = [aws_securityhub_account.member]
}

resource "aws_securityhub_standards_subscription" "aws_foundational" {
  standards_arn = "arn:aws:securityhub:ap-south-1::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_account.member]
}

output "securityhub_enabled" {
  description = "Security Hub enabled in member account"
  value       = "true"
}