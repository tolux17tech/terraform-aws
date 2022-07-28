resource "aws_default_security_group" "my-sg" {

  vpc_id = var.vpc_id

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
    values = [var.image_name]  #"amzn2-ami-hvm-*-x86_64-gp2"
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_key_pair" "server-key" {
  key_name   = "server-key"
  public_key = file(var.public_key)


}

resource "aws_instance" "web-server" {
  ami                         = data.aws_ami.latest-amazon-image.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
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