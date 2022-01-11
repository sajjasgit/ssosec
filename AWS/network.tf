resource "aws_vpc" "ssosec_vpc" {
  cidr_block           = var.network_name
  enable_dns_hostnames = true
  tags = merge(
    local.tags,
    {
      Name = local.network_name
    }
  )
}

resource "aws_subnet" "ssosec_public_subnet" {
  cidr_block        = var.subnet_cidr
  vpc_id            = aws_vpc.ssosec_vpc.id
  availability_zone = local.availability_zone
  tags = {
    Name = local.subnet_name
  }
}

resource "aws_route_table" "ssosec_public_rt" {
  vpc_id = aws_vpc.ssosec_vpc.id
  tags = {
    Name = local.route_table_name
  }
}

resource "aws_route_table_association" "ssosec_public_route_assoc" {
  route_table_id = aws_route_table.ssosec_public_rt.id
  subnet_id      = aws_subnet.ssosec_public_subnet.id
}

resource "aws_internet_gateway" "ssosec_igw" {
  vpc_id = aws_vpc.ssosec_vpc.id
  tags = {
    Name = local.igw_name
  }
}

resource "aws_route" "ssosec_igw_route" {
  route_table_id         = aws_route_table.ssosec_public_rt.id
  gateway_id             = aws_internet_gateway.ssosec_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl" "ssosec-nacl" {
  vpc_id     = aws_vpc.ssosec_vpc.id
  subnet_ids = [aws_subnet.ssosec_public_subnet.id]

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