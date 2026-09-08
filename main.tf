module "ec2" {
  source   = "./modules/ec2"
  for_each = { for item in local.ec2_config : item.name => item }

  name                 = each.value.name
  instance_type        = each.value.instance_type
  ami_id               = local.organization.ami_id
  subnet_id            = local.organization.ec2_subnet_id
  security_group_ids   = local.organization.security_group_ids
  iam_instance_profile = local.organization.iam_instance_profile
  key_name             = local.organization.ec2_key_name
  ansible_username     = local.organization.ansible_username
  root_volume          = { size = each.value.root_volume_size, type = "gp3", encrypted = true }
  monitoring           = true
  tags                 = local.organization.default_tags
}

module "s3" {
  source   = "./modules/s3"
  for_each = { for item in local.s3_config : item.bucket_name => item }

  bucket_name = each.value.bucket_name
  tags        = local.organization.default_tags
}

module "ebs" {
  source   = "./modules/ebs"
  for_each = { for item in local.ebs_config : item.name => item }

  name              = each.value.name
  size              = each.value.size
  availability_zone = local.organization.availability_zone
  instance_id       = module.ec2[each.value.instance_name].id
  device_name       = each.value.device_name
  kms_key_id        = local.organization.ebs_kms_key_id
  tags              = local.organization.default_tags
}

module "efs" {
  source   = "./modules/efs"
  for_each = { for item in local.efs_config : item.name => item }

  name               = each.value.name
  subnet_ids         = local.organization.subnet_ids
  security_group_ids = local.organization.security_group_ids
  kms_key_id         = local.organization.efs_kms_key_id
  performance_mode   = local.organization.efs_performance_mode
  throughput_mode    = local.organization.efs_throughput_mode
  transition_to_ia   = local.organization.efs_transition_to_ia
  tags               = local.organization.default_tags
}
