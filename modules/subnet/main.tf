resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block[0]
  availability_zone = var.az[0]

  tags = {
    Name = "${var.name}-subnet-1"
  }
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block[1]
  availability_zone = var.az[1]

  tags = {
    Name = "${var.name}-subnet-2"
  }
}

resource "aws_subnet" "dev-subnet-3" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block[2]
  availability_zone = var.az[2]

  tags = {
    Name = "${var.name}-subnet-3"
  }
}

resource "aws_internet_gateway" "my-gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-my-gw"
  }
}


resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = var.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gw.id
  }
  tags = {
    Name = "${var.name}-Main-rtb"
  }

}