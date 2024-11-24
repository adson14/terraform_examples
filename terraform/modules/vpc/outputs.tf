output "vpc_id" {
  value       = aws_vpc.new-vpc.id
  description = "ID da VPC criada"
}

output "private_subnet_ids" {
  value       = aws_subnet.subnets[*].id
  description = "IDs das subnets privadas"
}
