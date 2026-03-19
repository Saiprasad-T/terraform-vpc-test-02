#creating vpc
resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-vpc"
    },
    var.vpc_tags
  )
}
#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-igw"
    },
    var.igw_tags
  )
}
#creating subnets in two av zones

resource "aws_subnet" "public_snet" {
  count = length(var.pub_sub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub_cidr[count.index]
  availability_zone = var.az_zone[count.index]
  map_public_ip_on_launch = true
  

 tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-public-snet-${var.az_zone[count.index]}"
    },
    var.public_subnet_tags
  )
}

resource "aws_subnet" "private_snet" {
  count = length(var.pri_sub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pri_sub_cidr[count.index]
  availability_zone = var.az_zone[count.index]
  map_public_ip_on_launch = false
  

 tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-private-snet-${var.az_zone[count.index]}"
    },
    var.private_subnet_tags
  )
}

resource "aws_subnet" "db_snet" {
  count = length(var.db_sub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_sub_cidr[count.index]
  availability_zone = var.az_zone[count.index]
  map_public_ip_on_launch = false
  

 tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-db-snet-${var.az_zone[count.index]}"
    },
    var.db_subnet_tags
  )
}

#creating route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-public_rt"
    },
    var.public_rt
  )
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-private_rt"
    },
    var.private_rt
  )
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-db_rt"
    },
    var.db_rt
  )
}


resource "aws_route_table_association" "pub-ass" {
  count = length(var.pub_sub_cidr)
  subnet_id      = aws_subnet.public_snet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pri-ass" {
  count = length(var.pri_sub_cidr)
  subnet_id      = aws_subnet.private_snet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db-ass" {
  count = length(var.db_sub_cidr)
  subnet_id      = aws_subnet.db_snet[count.index].id
  route_table_id = aws_route_table.db_rt.id
}

#creating  eip
resource "aws_eip" "nat_eip" {
  domain   = "vpc"
  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-eip"
    }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_snet[0].id

  tags =  merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-natgw"
    },
    var.ngw_tags
  )
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
 #routes
 resource "aws_route" "pub_route" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

 resource "aws_route" "pri_route" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

 resource "aws_route" "db_route" {
  route_table_id            = aws_route_table.db_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}



