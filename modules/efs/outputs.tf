output "id" {
  description = "EFS file system ID."
  value       = aws_efs_file_system.this.id
}

output "arn" {
  description = "EFS file system ARN."
  value       = aws_efs_file_system.this.arn
}

output "dns_name" {
  description = "Regional DNS name used to mount the file system."
  value       = aws_efs_file_system.this.dns_name
}

output "mount_target_ids" {
  description = "Mount target IDs keyed by subnet ID."
  value       = { for subnet_id, target in aws_efs_mount_target.this : subnet_id => target.id }
}
