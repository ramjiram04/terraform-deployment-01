# JSON-driven AWS Terraform framework

This repository provisions EC2, S3, EBS, and EFS resources through Terraform and Jenkins. Deployment users edit only the files in `config/`; stable organization standards remain in `locals.tf`.

## Remote state

State is stored in `s3://cloud360-agent-statefile/terraform-generator/terraform.tfstate`. Native S3 lock-file locking prevents concurrent state modification. Jenkins reconfigures this backend non-interactively on every clean build.

## Deployment workflow

1. Add, update, or remove objects in the relevant `config/*.json` file. EC2 entries include `root_volume_size`; EBS entries identify the target `instance_name` and attachment `device_name`.
2. Commit the change and merge it into the branch monitored by Jenkins.
3. Jenkins checks formatting, validates the configuration, creates a saved plan, archives its JSON/text representations, waits for Cloud360 approval, and applies that exact plan. Cloud360 calculates an approximate cost from the plan using the AWS Pricing API.

Object names are stable `for_each` keys. Adding a unique object creates a resource, changing its key can cause replacement, and removing it plans deletion.

The EC2 bootstrap creates the configured Ansible user, installs Python 3, grants passwordless sudo, and copies the AMI login user's authorized keys. Password SSH is deliberately disabled.

Each EFS entry creates an encrypted file system and one mount target per configured subnet. The assigned security group must permit inbound NFS/TCP 2049 from EFS clients.
