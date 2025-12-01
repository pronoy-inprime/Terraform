variable "private_subnet_01_vpc01" {
    description =  "VPC Private Subnet 01 Cidr"
    type = string
}
variable "private_subnet_02_vpc01" {
    description =  "VPC Private Subnet 02 Cidr"
    type = string
}
variable "vpc_id" {
    description = "VPC ID where DocumentDB will be deployed"
    type = string
}
variable "vpc_cidr_block" {
  type = string
  description = "CIDR block of the VPC that should be allowed to access DocumentDB"
}