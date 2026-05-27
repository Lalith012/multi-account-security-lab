variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "ap-south-1"
}

variable "management_account_id" {
  description = "AWS Management Account ID"
  type        = string
  default     = "986151953551"
}

variable "member_account_id" {
  description = "AWS Member Account ID"
  type        = string
  default     = "664858858896"
}

variable "environment" {
  description = "Environment tag for all resources"
  type        = string
  default     = "security-lab"
}

variable "cloudtrail_bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
  default     = "cloudtrail-logs-664858858896"
}