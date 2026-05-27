# -------------------------------------------------------
# Security Hub — Management Account
# Delegated Administrator for the Organization
# Account: 986151953551
# -------------------------------------------------------

resource "aws_securityhub_account" "management" {
  enable_default_standards = false
}

resource "aws_securityhub_organization_admin_account" "management" {
  admin_account_id = var.management_account_id
  depends_on       = [aws_securityhub_account.management]
}

resource "aws_securityhub_organization_configuration" "main" {
  auto_enable           = true
  auto_enable_standards = "NONE"
  depends_on            = [aws_securityhub_organization_admin_account.management]
}

output "securityhub_management_arn" {
  description = "Security Hub ARN in management account"
  value       = aws_securityhub_account.management.arn
}