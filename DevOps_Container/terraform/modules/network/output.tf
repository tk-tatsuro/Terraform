# ----------------------------------
# network output
# ----------------------------------
output "alb_target_group" {
    value = aws_alb_target_group.archetype_alb_tg.arn
    sensitive = true
}
output "security_group_api" {
    value = aws_security_group.archetype_api_sg.id
    sensitive = true
}
output "security_group_alb" {
    value = aws_security_group.archetype_alb_sg.id
    sensitive = true
}
output "security_group_db" {
    value = aws_security_group.praivate_db_sg.id
    sensitive = true
}
