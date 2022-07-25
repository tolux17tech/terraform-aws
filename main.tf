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


module "my-subnet" {
  source = "./modules/subnet"
  cidr_block = var.cidr_block
  az = var.az
  name = var.name
  vpc_id = aws_vpc.dev-vpc.id
  default_route_table_id = aws_vpc.dev-vpc.default_route_table_id
}

module "my-webserver" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.dev-vpc.id
  #cidr_block = var.cidr_block
  az = var.az
  name = var.name
  instance_type = var.instance_type
  public_key = var.public_key
  private_key = var.private_key
  subnet_id = module.my-subnet.subnet2.id
  public_ip = var.public_ip

}


resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.name}-Vpc"
  }
}




/* resource "aws_route_table" "my-dev-rtb" {
    vpc_id = aws_vpc.dev-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-gw.id
    }
    tags = {
        Name = "${var.name}-my-dev-rtb"
    }
} */

/* resource "aws_route_table_association" "rta" {

  
  subnet_id      = aws_subnet.dev-subnet-3.id
  route_table_id = aws_route_table.my-dev-rtb.id
}

resource "aws_route_table_association" "rtb" {
  
  subnet_id      = aws_subnet.dev-subnet-2.id
  route_table_id = aws_route_table.my-dev-rtb.id
}

resource "aws_route_table_association" "rtc" {
  
  subnet_id      = aws_subnet.dev-subnet-1.id
  route_table_id = aws_route_table.my-dev-rtb.id
} */