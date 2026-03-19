output "vpc_id" {
  value       = aws_vpc.main.id
}

output "natgtw_id" {
  value       = aws_nat_gateway.main.id
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
}

output "eip_pub_ip" {
  value       = aws_eip.nat_eip.public_ip
}

