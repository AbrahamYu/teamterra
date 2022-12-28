output "vpc_GeC_IDC" {
  description = "The name is VPC Global eCommerce IDC"
  value       = aws_vpc.VPC_GeC_IDC.id
}

output "vpc_name" {
  description = "vpc_name"
  value       = var.tag_name
}

output "igw_id" {
  description = "igw_id"
  value       = aws_internet_gateway.VPC_GeC_IDC_IGW
}

output "route_id" {
  description = "route_id"
  value       = aws_route_table.VPC_GeC_IDC_RT.id

}
