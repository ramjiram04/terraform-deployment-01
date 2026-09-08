terraform {
  required_version = ">= 1.10.0"

  # The original POC bucket name (cloud360-agent-statefile) is globally taken
  # by another AWS account, and the service control policy denies creating new
  # buckets in this account, so the state lives in the provisioned bucket
  # jvbsfazujkhvilu under a dedicated prefix.
  backend "s3" {
    bucket       = "cloudops360-agent"
    key          = "terraform-generator/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
