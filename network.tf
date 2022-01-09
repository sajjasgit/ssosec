resource "aws_vpc" "ssosec-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_subnet" "ssosec-public-subnet" {
  cidr_block        = var.public_subnet_cidr
  vpc_id            = aws_vpc.ssosec-vpc.id
  availability_zone = local.availability_zone
  tags = {
    Name = local.public_subnet_name
  }
}

resource "aws_route_table" "ssosec-public-rt" {
  vpc_id = aws_vpc.ssosec-vpc.id
  tags = {
    Name = local.public_rt_name
  }
}

resource "aws_route_table_association" "ssosec-public-route-assoc" {
  route_table_id = aws_route_table.ssosec-public-rt.id
  subnet_id      = aws_subnet.ssosec-public-subnet.id
}

resource "aws_internet_gateway" "ssosec-igw" {
  vpc_id = aws_vpc.ssosec-vpc.id
  tags = {
    Name = local.igw_name
  }
}

resource "aws_route" "ssosec-igw-route" {
  route_table_id         = aws_route_table.ssosec-public-rt.id
  gateway_id             = aws_internet_gateway.ssosec-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl" "ssosec-nacl" {
  vpc_id     = aws_vpc.ssosec-vpc.id
  subnet_ids = [aws_subnet.ssosec-public-subnet.id]

  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    rule_no    = 102
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.ssh_location
    from_port  = 22
    to_port    = 22
  }

  egress {
    rule_no    = 103
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 101
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    rule_no    = 102
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.ssh_location
    from_port  = 22
    to_port    = 22
  }

  ingress {
    rule_no    = 103
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = local.nacl_name
  }
}