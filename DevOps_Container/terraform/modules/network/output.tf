# ----------------------------------
# network output
# ----------------------------------
output "alb_target_group" {
    value = aws_alb_target_group.archetype.arn
    sensitive = true
}
output "alb_security_group_api" {
    value = aws_security_group.archetype_api.id
    sensitive = true
}
output "alb_security_group_alb" {
    value = aws_security_group.archetype_alb.id
    sensitive = true
}