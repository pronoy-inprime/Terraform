output "vpc_inprime_01_id" {
    value = aws_vpc.vpc_inprime_01.id
}
output "private_subnet_01_vpc01_id" {
    value = aws_subnet.private_subnet_01_vpc01.id
}
output "public_subnet_01_vpc01_id" {
    value = aws_subnet.public_subnet_01_vpc01.id
}
output "public_subnet_02_vpc01_id" {
    value = aws_subnet.public_subnet_02_vpc01.id
}