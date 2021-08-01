output "vpc_id" {
  value = aws_vpc.infra.id
}

output "vpc_cidr_block" {
  value = aws_vpc.infra.cidr_block
}

output "public_subnet" {
  value = aws_subnet.public[*].id
}

output "public_subnet_cidr" {
  value = aws_subnet.public[*].cidr_block
}

output "private_subnet" {
  value = aws_subnet.private[*].id
}

output "private_subnet_cidr" {
  value = aws_subnet.private[*].cidr_block
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.infra.name
}