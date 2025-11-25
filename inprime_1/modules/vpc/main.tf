#vpc
resource "aws_vpc" "vpc_inprime_01" {
  cidr_block = var.vpc_inprime_01
  instance_tenancy = "default"
  
  tags = {
    Name = "vpc_inprime_01"
  }
}
#subnets
resource "aws_subnet" "public_subnet_01_vpc01" {
  vpc_id     = aws_vpc.vpc_inprime_01.id
  cidr_block = var.public_subnet_01_vpc01
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_01_vpc01"
  }
}

resource "aws_subnet" "public_subnet_02_vpc01" {
  vpc_id     = aws_vpc.vpc_inprime_01.id
  cidr_block = var.public_subnet_02_vpc01
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_02_vpc01"
  }
}

resource "aws_subnet" "private_subnet_01_vpc01" {
  vpc_id     = aws_vpc.vpc_inprime_01.id
  cidr_block = var.private_subnet_01_vpc01
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet_01_vpc01"
  }
}
resource "aws_subnet" "private_subnet_02_vpc01" {
  vpc_id     = aws_vpc.vpc_inprime_01.id
  cidr_block = var.private_subnet_02_vpc01
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet_02_vpc01"
  }
}
#internet gateway
resource "aws_internet_gateway" "igw_vpc01" {
  vpc_id = aws_vpc.vpc_inprime_01.id

  tags = {
    Name = "igw_vpc01"
  }
}
#route table
resource "aws_route_table" "public_rt_vpc01" {
  vpc_id = aws_vpc.vpc_inprime_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_vpc01.id
  }

  tags = {
    Name = "public_rt_vpc01"
  }
}

resource "aws_route_table" "private_rt_vpc01" {
  vpc_id = aws_vpc.vpc_inprime_01.id

  tags = {
    Name = "private_rt_vpc01"
  }
}

#route table association

resource "aws_route_table_association" "rt_association_01" {
  subnet_id = aws_subnet.public_subnet_01_vpc01.id
  route_table_id = aws_route_table.public_rt_vpc01.id
}

resource "aws_route_table_association" "rt_association_02" {
  subnet_id      = aws_subnet.private_subnet_01_vpc01.id
  route_table_id = aws_route_table.private_rt_vpc01.id
}

resource "aws_route_table_association" "rt_association_03" {
  subnet_id = aws_subnet.public_subnet_02_vpc01.id
  route_table_id = aws_route_table.public_rt_vpc01.id
}

resource "aws_route_table_association" "rt_association_04" {
  subnet_id      = aws_subnet.private_subnet_02_vpc01.id
  route_table_id = aws_route_table.private_rt_vpc01.id
}

resource "aws_eip" "nat_eip" {
  domain   = "vpc"
  depends_on = [aws_internet_gateway.igw_vpc01]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_01_vpc01.id
  depends_on    = [aws_internet_gateway.igw_vpc01]
  tags = {
    Name = "nat_gateway_vpc01"
  }
}
resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.private_rt_vpc01.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}