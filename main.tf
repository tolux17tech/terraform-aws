terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.23.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
  # Configuration options
}

variable "name" {}
variable "cidr_block"{
    type = list(string)
}

resource "aws_vpc" "dev-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "${var.name}-Vpc"
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.cidr_block[0]
    availability_zone = "us-east-1c"

    tags = {
        Name = "${var.name}-subnet-1"
    }
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.cidr_block[1]
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.name}-subnet-2"
    }
}

resource "aws_subnet" "dev-subnet-3" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.cidr_block[2]
    availability_zone = "us-east-1b"

    tags = {
        Name = "${var.name}-subnet-3"
    }
}


