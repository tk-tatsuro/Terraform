# ----------------------------------
# Security Group & ALB
# ----------------------------------
resource "aws_security_group" "archetype_alb" {
  name = "archetype-alb"
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

resource "aws_security_group" "archetype_api" {
  name = "archetype-api"
  vpc_id = "${var.aws_vpc_cntn}"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_groups = ["${aws_security_group.archetype_alb.id}",]
  }

  # ingress {
  #   from_port = 443
  #   to_port = 443
  #   protocol = "tcp"
  #   security_groups = ["${aws_security_group.archetype_alb.id}",]
  # }

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


# Create ALB
resource "aws_alb" "archetype" {
  name = "archetype"
  security_groups = ["${aws_security_group.archetype_alb.id}"]
  subnets = [
    "${var.aws_subnet_a}",
    "${var.aws_subnet_b}",
  ]
  internal = false
  enable_deletion_protection = true
  access_logs {
    bucket = "${var.aws_s3_bucket_cntn}"
    enabled = true
  }
}

resource "aws_alb_target_group" "archetype" {
  name = "archetype"
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

resource "aws_alb_listener" "archetype" {
  load_balancer_arn = "${aws_alb.archetype.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.archetype.arn}"
    type = "forward" # Send on request to Target Group
  }
}