output "vpc_id" {
  value       = aws_vpc.main.id
}

output "az_info" {
  value       = aws_subnet.main.availability_zone.available.names
}

