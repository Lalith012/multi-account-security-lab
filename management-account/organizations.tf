# -------------------------------------------------------
# AWS Organizations Configuration
# Management Account: 986151953551
# -------------------------------------------------------

# Reference the existing organization (already created manually)
data "aws_organizations_organization" "org" {}

# -------------------------------------------------------
# Organizational Units
# -------------------------------------------------------

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

# -------------------------------------------------------
# Outputs
# -------------------------------------------------------

output "organization_id" {
  description = "AWS Organization ID"
  value       = data.aws_organizations_organization.org.id
}

output "root_id" {
  description = "Organization Root ID"
  value       = data.aws_organizations_organization.org.roots[0].id
}

output "ou_security_id" {
  description = "Security OU ID"
  value       = aws_organizations_organizational_unit.security.id
}

output "ou_workloads_id" {
  description = "Workloads OU ID"
  value       = aws_organizations_organizational_unit.workloads.id
}

output "ou_sandbox_id" {
  description = "Sandbox OU ID"
  value       = aws_organizations_organizational_unit.sandbox.id
}