resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    ansible_username = var.ansible_username
  })

  root_block_device {
    volume_size = var.root_volume.size
    volume_type = var.root_volume.type
    encrypted   = var.root_volume.encrypted
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(var.tags, { Name = var.name })

  lifecycle {
    precondition {
      condition     = can(regex("^[a-z_][a-z0-9_-]*$", var.ansible_username))
      error_message = "ansible_username must be a valid Linux username."
    }
  }
}
