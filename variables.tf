variable "name" {}
variable "cidr_block" {
  type = list(string)
}
variable "az" {
  type = list(string)
}
variable "public_ip" {}

variable "instance_type" {}
variable "public_key" {}
variable "private_key" {}