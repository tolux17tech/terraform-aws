name       = "Dev"
cidr_block = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
az         = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_ip  = "173.175.206.123/32"

instance_type = "t2.micro"

public_key  = "/Users/dc/.ssh/id_rsa.pub"
private_key = "/Users/dc/.ssh/id_rsa"
image_name = "amzn2-ami-hvm-*-x86_64-gp2"