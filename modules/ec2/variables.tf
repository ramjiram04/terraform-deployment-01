variable "name" { type = string }
variable "instance_type" { type = string }
variable "ami_id" { type = string }
variable "subnet_id" { type = string }
variable "security_group_ids" { type = list(string) }
variable "iam_instance_profile" { type = string }
variable "key_name" { type = string }
variable "ansible_username" { type = string }
variable "monitoring" { type = bool }
variable "tags" { type = map(string) }
variable "root_volume" {
  type = object({ size = number, type = string, encrypted = bool })
}
