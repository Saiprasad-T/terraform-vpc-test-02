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

resource "aws_subnet" "main" {
  count = length(var.pub_sub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub_cidr[count.index]
  availability_zone = var.az_zone[count.index]
  

 tags = merge (
    local.common_tags,
    {
        name = "${var.project}-${var.environment}-${var.az_zone[count.index]}"
    },
    var.public_subnet_tags
  )
}