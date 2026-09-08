output "ec2_instances" {
  value = { for key, item in module.ec2 : key => { id = item.id, private_ip = item.private_ip, public_ip = item.public_ip } }
}

output "s3_buckets" {
  value = { for key, item in module.s3 : key => item.arn }
}

output "ebs_volumes" {
  value = { for key, item in module.ebs : key => { id = item.id, attachment_id = item.attachment_id } }
}

output "efs_file_systems" {
  value = { for key, item in module.efs : key => { id = item.id, dns_name = item.dns_name, mount_target_ids = item.mount_target_ids } }
}
