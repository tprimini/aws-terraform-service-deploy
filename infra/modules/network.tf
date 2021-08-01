# VPC ##################################################################################################################

resource "aws_vpc" "infra" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-${var.region}-infra"
  }
}

# Subnets ##############################################################################################################

resource "aws_subnet" "private" {
  count             = length(var.azs)
  cidr_block        = cidrsubnet(aws_vpc.infra.cidr_block, 8, count.index) // 10.0.0.0/24, 10.0.1.0/24, ...
  vpc_id            = aws_vpc.infra.id
  availability_zone = "${var.region}${element(var.azs, count.index)}"
  tags = {
    Name = "${var.environment}-${var.region}-infra-private-${count.index}"
    Tier = "private"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.azs)
  cidr_block        = cidrsubnet(aws_vpc.infra.cidr_block, 8, length(var.azs) + count.index)  // 10.0.2.0/24, 10.0.3.0/24, ...
  vpc_id            = aws_vpc.infra.id
  availability_zone = "${var.region}${element(var.azs, count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.environment}-${var.region}-infra-public-${count.index}"
    Tier = "public"
  }
}

# Internet Gateway #####################################################################################################

resource "aws_internet_gateway" "infra" {
  vpc_id = aws_vpc.infra.id
  tags = {
    Name = "${var.environment}-${var.region}-infra-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.infra.id
  tags = {
    Name = "${var.environment}-${var.region}-infra-public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.infra.id
}

# NAT Gateway ##########################################################################################################

resource "aws_eip" "infra" {
  count = length(var.azs)
  tags = {
    Name = "${var.environment}-${var.region}-infra-${count.index}"
  }
}

resource "aws_nat_gateway" "infra" {
  count         = length(var.azs)
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.infra[count.index].id
  depends_on    = [aws_internet_gateway.infra]
  tags = {
    Name = "${var.environment}-${var.region}-infra-${count.index}"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.infra.id
  tags = {
    Name = "${var.environment}-${var.region}-infra-private-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "private" {
  count = length(var.azs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.infra[count.index].id
}