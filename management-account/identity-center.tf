# -------------------------------------------------------
# IAM Identity Center (SSO) Configuration
# Identity Store ID: d-9f67527363
# -------------------------------------------------------

# Reference the existing IAM Identity Center instance
data "aws_ssoadmin_instances" "main" {}

locals {
  sso_instance_arn      = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  identity_store_id     = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}

# -------------------------------------------------------
# Permission Set 1: SecurityAdminAccess
# -------------------------------------------------------

resource "aws_ssoadmin_permission_set" "security_admin" {
  name             = "SecurityAdminAccess"
  description      = "Full access to security services - GuardDuty, Security Hub, CloudTrail, Config"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "security_admin_policy" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.security_admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# -------------------------------------------------------
# Permission Set 2: ReadOnlyAccess
# -------------------------------------------------------

resource "aws_ssoadmin_permission_set" "read_only" {
  name             = "ReadOnlyAccess"
  description      = "Read-only access across all AWS services"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT4H"
}

resource "aws_ssoadmin_managed_policy_attachment" "read_only_policy" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.read_only.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# -------------------------------------------------------
# Outputs
# -------------------------------------------------------

output "sso_instance_arn" {
  description = "IAM Identity Center instance ARN"
  value       = local.sso_instance_arn
}

output "permission_set_security_admin_arn" {
  description = "SecurityAdminAccess permission set ARN"
  value       = aws_ssoadmin_permission_set.security_admin.arn
}

output "permission_set_read_only_arn" {
  description = "ReadOnlyAccess permission set ARN"
  value       = aws_ssoadmin_permission_set.read_only.arn
}