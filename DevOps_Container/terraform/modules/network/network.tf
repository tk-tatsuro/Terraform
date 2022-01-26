# ----------------------------------
# Security Group & ALB
# ----------------------------------
## security group public
resource "aws_security_group" "archetype_alb_sg" {
  name = "archetype-alb-sg"
  vpc_id = "${var.aws_vpc_cntn}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Archetype ALB SG"
  }
}
## security group public
resource "aws_security_group" "archetype_api_sg" {
  name = "archetype-api-sg"
  vpc_id = "${var.aws_vpc_cntn}"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_groups = ["${aws_security_group.archetype_alb_sg.id}",]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Archetype API SG"
  }
}
## security group private
resource "aws_security_group" "praivate_db_sg" {
  name = "praivate-db-sg"
  vpc_id = "${var.aws_vpc_cntn}"
  ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = ["10.0.128.0/24"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "public-db-sg"
  }
}


# Create ALB
resource "aws_alb" "archetype_alb" {
  name = "archetype-alb"
  security_groups = ["${aws_security_group.archetype_alb_sg.id}"]
  subnets = [
    "${var.aws_public_subnet_a}",
    "${var.aws_public_subnet_b}",
  ]
  internal = false
  enable_deletion_protection = false
  access_logs {
    bucket = "${var.aws_s3_bucket_cntn}"
    enabled = true
  }
}

resource "aws_alb_target_group" "archetype_alb_tg" {
  name = "archetype-alb-tg"
  port = 8000
  protocol = "HTTP"
  vpc_id = "${var.aws_vpc_cntn}"
  target_type = "ip"

  health_check {
    interval = 60
    path = "/health_check"
    port = 80
    protocol = "HTTP"
    timeout = 30
    unhealthy_threshold = 3
    matcher = 200
  }
}

resource "aws_alb_listener" "archetype_alb_listener" {
  load_balancer_arn = "${aws_alb.archetype_alb.arn}"
  port = "80"
  protocol = "HTTP"
  
  default_action {
    target_group_arn = "${aws_alb_target_group.archetype_alb_tg.arn}"
    type = "forward" # Send on request to Target Group
  }
}