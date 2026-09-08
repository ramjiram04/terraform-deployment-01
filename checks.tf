check "ec2_configuration" {
  assert {
    condition = alltrue([
      for item in local.ec2_config :
      can(item.name) && can(item.instance_type) && can(item.root_volume_size) &&
      trimspace(item.name) != "" && trimspace(item.instance_type) != "" && item.root_volume_size >= 8
    ]) && length(distinct([for item in local.ec2_config : item.name])) == length(local.ec2_config)
    error_message = "Each EC2 entry requires a non-empty unique name, a non-empty instance_type, and root_volume_size of at least 8 GiB."
  }
}

check "s3_configuration" {
  assert {
    condition = alltrue([
      for item in local.s3_config : can(item.bucket_name) && trimspace(item.bucket_name) != ""
    ]) && length(distinct([for item in local.s3_config : item.bucket_name])) == length(local.s3_config)
    error_message = "Each S3 entry requires a non-empty, unique bucket_name."
  }
}

check "ebs_configuration" {
  assert {
    condition = (
      alltrue([
        for item in local.ebs_config :
        can(item.name) && can(item.size) && can(item.instance_name) && can(item.device_name) &&
        trimspace(item.name) != "" && item.size > 0 &&
        contains([for instance in local.ec2_config : instance.name], item.instance_name) &&
        can(regex("^/dev/[a-zA-Z0-9]+$", item.device_name))
      ]) &&
      length(distinct([for item in local.ebs_config : item.name])) == length(local.ebs_config) &&
      length(distinct([for item in local.ebs_config : "${item.instance_name}:${item.device_name}"])) == length(local.ebs_config)
    )
    error_message = "Each EBS entry requires a unique non-empty name, positive size, existing EC2 instance_name, valid device_name, and a unique instance/device pairing."
  }
}

check "efs_configuration" {
  assert {
    condition = alltrue([
      for item in local.efs_config : can(item.name) && trimspace(item.name) != ""
    ]) && length(distinct([for item in local.efs_config : item.name])) == length(local.efs_config)
    error_message = "Each EFS entry requires a non-empty, unique name."
  }
}
