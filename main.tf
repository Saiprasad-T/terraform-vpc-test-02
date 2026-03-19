#creating vpc
resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge (
    local.common_tags,
    {
        name = "${var.project}-${var.environment}-vpc"
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
        name = "${var.project}-${var.environment}-igw"
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
        name = "${var.project}-${var.environment}-public-snet-${var.az_zone[count.index]}"
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
        name = "${var.project}-${var.environment}-private-snet-${var.az_zone[count.index]}"
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
        name = "${var.project}-${var.environment}-db-snet-${var.az_zone[count.index]}"
    },
    var.db_subnet_tags
  )
}


