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



resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.name}-Vpc"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.cidr_block[0]
  availability_zone = var.az[0]

  tags = {
    Name = "${var.name}-subnet-1"
  }
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.cidr_block[1]
  availability_zone = var.az[1]

  tags = {
    Name = "${var.name}-subnet-2"
  }
}

resource "aws_subnet" "dev-subnet-3" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.cidr_block[2]
  availability_zone = var.az[2]

  tags = {
    Name = "${var.name}-subnet-3"
  }
}

resource "aws_internet_gateway" "my-gw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "${var.name}-my-gw"
  }
}


resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.dev-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gw.id
  }
  tags = {
    Name = "${var.name}-Main-rtb"
  }

}

resource "aws_default_security_group" "my-sg" {

  vpc_id = aws_vpc.dev-vpc.id

  ingress {
    description = "SSH TO VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_ip]

  }

  ingress {
    description = "OPEN EC2"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "${var.name}-default-sg"
  }
}

data "aws_ami" "latest-amazon-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {

    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web-server" {
  ami                         = data.aws_ami.latest-amazon-image.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.dev-subnet-3.id
  vpc_security_group_ids      = [aws_default_security_group.my-sg.id]
  associate_public_ip_address = true
  /* availability_zone = var.az[1] */
  key_name  = "server-key"
  user_data = file("freestyle.sh")

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key)
  }


  provisioner "remote-exec" {
    inline = [
      "mkdir tolu{1992,1993}",
      "echo 'I am blessed' tolu{1992,1993}"
    ]

  }
}

resource "aws_key_pair" "server-key" {
  key_name   = "server-key"
  public_key = file(var.public_key)


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