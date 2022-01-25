# ----------------------------------
# instance output
# ----------------------------------
output "aws_vpc_cntn" {
    value = aws_vpc.archetype.id
    sensitive = true
}
output "aws_subnet_a" {
    value = aws_subnet.api_a.id
    sensitive = true
}
output "aws_subnet_b" {
    value = aws_subnet.api_b.id
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