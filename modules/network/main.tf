#VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = false
}
#PUBLIC SUBNET
resource "aws_subnet" "pub_sub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub
}
#PRIVATE SUBNET
resource "aws_subnet" "pri_sub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pri_sub
}
#IGW
resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
}
#NGW
resource "aws_nat_gateway" "ngw" {
allocation_id = aws_eip.eip.id
subnet_id     = aws_subnet.pri_sub.id
}
#EIP
resource "aws_eip" "eip" {
 vpc = true
}
#PUBLIC ROUTE TABLE
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.main.id
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  }
}
#PRIVATE ROUTE TABLE
resource "aws_route_table" "pri_rt" {
 vpc_id = aws_vpc.main.id
 route {
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_nat_gateway.ngw.id
  }
}
#PUBLIC SUBNET ASSOCIATION
resource "aws_route_table_association" "pub_asc" {
  subnet_id      = aws_subnet.pub_sub.id
  route_table_id = aws_route_table.pub_rt.id
}