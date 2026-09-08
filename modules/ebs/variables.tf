variable "name" { type = string }
variable "size" { type = number }
variable "availability_zone" { type = string }
variable "instance_id" { type = string }
variable "device_name" { type = string }
variable "kms_key_id" {
  type    = string
  default = null
}
variable "tags" { type = map(string) }
