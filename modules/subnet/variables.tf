variable "vpc_id" {}
variable "default_route_table_id"{}
variable "name" {}
variable "cidr_block" {
  type = list(string)
}
variable "az" {
  type = list(string)
}