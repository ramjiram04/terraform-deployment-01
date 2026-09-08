locals {
  # Organization standards: maintained by the platform team, not deployment users.
  # Identifiers discovered for AWS account 645311222557 (default VPC, us-east-1)
  # during the CloudOps360 POC server recreation.
  organization = {
    aws_region           = "us-east-1"
    subnet_ids           = ["subnet-08c222d582c7a15e6", "subnet-0ed1e2ca507434ed9", "subnet-0f3823c055a5af233"]
    ec2_subnet_id        = "subnet-08c222d582c7a15e6"
    security_group_ids   = ["sg-0fc037e7d849c2c6d"]
    ami_id               = "ami-0b6d9d3d33ba97d99"
    iam_instance_profile = null
    ec2_key_name         = "agenticai"
    ansible_username     = "agenticai"
    availability_zone    = "us-east-1a"
    ebs_kms_key_id       = null
    efs_kms_key_id       = null
    efs_performance_mode = "generalPurpose"
    efs_throughput_mode  = "bursting"
    efs_transition_to_ia = "AFTER_30_DAYS"
    default_tags = {
      ManagedBy   = "Terraform"
      Environment = "production"
      Owner       = "platform-team"
    }
  }

  config_path = "${path.root}/config"
  ec2_config  = jsondecode(file("${local.config_path}/ec2.json"))
  s3_config   = jsondecode(file("${local.config_path}/s3.json"))
  ebs_config  = jsondecode(file("${local.config_path}/ebs.json"))
  efs_config  = jsondecode(file("${local.config_path}/efs.json"))
}
