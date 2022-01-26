# ----------------------------------
# Security Group & ALB
# ----------------------------------
# Create the ECS Cluster
resource "aws_ecs_cluster" "archetype" {
  name = "archetype"
}

# Create the Cloudwatch-log-group
resource "aws_cloudwatch_log_group" "archetype_api" {
  name = "/ecs/api"
  retention_in_days = 180
}
resource "aws_cloudwatch_log_group" "archetype_nginx" {
  name = "/ecs/nginx"
  retention_in_days = 180
}


# Create the ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecs-task-execution"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_role.json}"
}
data "aws_iam_policy_document" "ecs_tasks_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_policy_attachment" "ecs_task_execution" {
  name = "ecs-task-execution"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles = ["${aws_iam_role.ecs_task_execution.name}"]
}
resource "aws_iam_role_policy" "role_policy_ecs_task_execution" {
  name = "role_policy_ecs_task_execution"
  role = aws_iam_role.ecs_task_execution.id

  policy = <<-EOF 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["ecs:*", "ecr:*"],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "*"
        }
    ]
}
  EOF
}


resource "aws_vpc_endpoint" "ecr_api" {
  service_name      = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type = "Interface"
  vpc_id            = var.aws_vpc_cntn
  subnet_ids        = [var.aws_public_subnet_a, var.aws_public_subnet_b]
  security_group_ids = [
    var.security_group_api,
  ]
  private_dns_enabled = true
  tags = {
    "Name" = "ecr-api"
  }
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  service_name      = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  vpc_id            = var.aws_vpc_cntn
  subnet_ids        = [var.aws_public_subnet_a, var.aws_public_subnet_b]
  security_group_ids = [
    var.security_group_api,
  ]
  private_dns_enabled = true
  tags = {
    "Name" = "ecr-dkr"
  }
}


#----------------------------------
# ECS task definition : nginx
# ----------------------------------
data "template_file" "container_definitions" {
  template = file("./modules/container/container_definitions.json")
}
locals {
  name = "django-nginx"
}
resource "aws_ecs_task_definition" "task_definition" {
  family = local.name
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = data.template_file.container_definitions.rendered
  execution_role_arn    = aws_iam_role.api_role.arn
}
resource "aws_iam_role" "api_role" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
# ----------------------------------
# ceate ecs service
# ----------------------------------
resource "aws_ecs_service" "ecs_service" {
  name            = "${local.name}-service"
  launch_type     = "FARGATE"
  desired_count   = "1"
  cluster         = aws_ecs_cluster.archetype.name
  task_definition = aws_ecs_task_definition.task_definition.arn
  
  network_configuration {
    security_groups  = [
      "${var.security_group_api}"
    ]
    subnets = [
      "${var.aws_public_subnet_a}",
      "${var.aws_public_subnet_b}",
    ]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.alb_target_group
    container_name   = "nginx"
    container_port   = 80
  }
}




#----------------------------------
# ECS task definition : api(Django)
# ----------------------------------
data "template_file" "container_definitions_api" {
  template = file("./modules/container/container_definitions_api.json")
}
locals {
  api_name = "django-api"
}
resource "aws_ecs_task_definition" "task_definition_api" {
  family = "${local.api_name}"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = data.template_file.container_definitions_api.rendered
  execution_role_arn    = aws_iam_role.api_role.arn
}
# ----------------------------------
# ceate ecs service
# ----------------------------------
resource "aws_ecs_service" "ecs_service_api" {
  name            = "${local.api_name}-service-api"
  launch_type     = "FARGATE"
  desired_count   = "2"
  cluster         = aws_ecs_cluster.archetype.name
  task_definition = aws_ecs_task_definition.task_definition_api.arn
  health_check_grace_period_seconds = 60
  
  network_configuration {
    security_groups  = [
      "${var.security_group_api}"
    ]
    subnets = [
      "${var.aws_public_subnet_a}",
      "${var.aws_public_subnet_b}",
    ]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.alb_target_group
    container_name   = "api"
    container_port   = "8000"
  }
}
