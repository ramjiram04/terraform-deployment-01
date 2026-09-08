variable "name" {
  description = "Stable name of the EFS file system."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets in which EFS mount targets are created. Use at most one subnet per availability zone."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups assigned to every EFS mount target."
  type        = list(string)
}

variable "kms_key_id" {
  description = "Optional customer-managed KMS key ARN or ID. The AWS-managed EFS key is used when null."
  type        = string
  default     = null
}

variable "performance_mode" {
  description = "EFS performance mode."
  type        = string
}

variable "throughput_mode" {
  description = "EFS throughput mode."
  type        = string
}

variable "transition_to_ia" {
  description = "Inactivity period before files transition to EFS Infrequent Access."
  type        = string
}

variable "tags" {
  description = "Organization tags."
  type        = map(string)
}
