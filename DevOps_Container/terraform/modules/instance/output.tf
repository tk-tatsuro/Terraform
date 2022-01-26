# ----------------------------------
# instance output
# ----------------------------------
output "aws_vpc_cntn" {
    value = aws_vpc.archetype.id
    sensitive = true
}
output "aws_public_subnet_a" {
    value = aws_subnet.public_subnet_api_a.id
    sensitive = true
}
output "aws_public_subnet_b" {
    value = aws_subnet.public_subnet_api_b.id
    sensitive = true
}
output "aws_private_subnet_a" {
    value = aws_subnet.private_subnet_db_a.id
    sensitive = true
}
output "aws_private_subnet_b" {
    value = aws_subnet.private_subnet_db_b.id
    sensitive = true
}
output "aws_vpc_cidr_block" {
    value = aws_vpc.archetype.cidr_block
    sensitive = true
}
output "aws_vpc_ipv6_cidr_block" {
    value = aws_vpc.archetype.ipv6_cidr_block
    sensitive = true
}