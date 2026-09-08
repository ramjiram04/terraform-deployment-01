provider "aws" {
  region = local.organization.aws_region

  default_tags {
    tags = local.organization.default_tags
  }
}
