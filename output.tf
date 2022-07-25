output "Vpc-id" {
    value = aws_vpc.dev-vpc.id
}

output "subnet1" {
    value = aws_subnet.dev-subnet-1.id
}

output "subnet2" {
    value = aws_subnet.dev-subnet-2.id
}

output "subnet3" {
    value = aws_subnet.dev-subnet-3.id
} 

