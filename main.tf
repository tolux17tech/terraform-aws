terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}

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
variable "image_name"{}



resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.name}-Vpc"
  }
}

module "subnet" {
  source = "/Users/dc/Documents/Terraform-AWS/modules/subnet"
  vpc_id = aws_vpc.dev-vpc.id 
  cidr_block = var.cidr_block
  az = var.az
  name = var.name
  default_route_table_id =aws_vpc.dev-vpc.default_route_table_id  
}

/* variable "vpc_id" {}
variable "public_Ip"{}
variable "name" {}
variable "image_name"{}
variable "public_key"{}
variable "instance_type"{}
variable "subnet_id"{}
variable "private_key"{} */

module "webserver" {
  source = "/Users/dc/Documents/Terraform-AWS/modules/webserver"
  vpc_id = aws_vpc.dev-vpc.id 
  name = var.name
  image_name = var.image_name
  public_key = var.public_key
  instance_type = var.instance_type 
  subnet_id = module.subnet.subnetc.id   
  private_key = var.private_key
  public_ip = var.public_ip
}






