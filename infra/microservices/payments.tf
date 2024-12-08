resource "aws_lb" "payments_lb" {
  for_each           = var.environments
  name               = "payments-lb-${each.value}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer-ingress-security-group.id]
  subnets            = [var.subnet1, var.subnet2]
  tags = {
    Name = "payments-lb-${each.value}"
  }
}


resource "aws_lb_target_group" "payments_tg" {
  for_each    = var.environments
  name        = "payments-tg-${each.value}"
  port        = 8080
  target_type = "ip"
  protocol    = "HTTP" # Changed from "TCP" to "HTTP"
  vpc_id      = var.vpc
  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200,404"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "payments_lb_listener" {
  for_each          = var.environments
  load_balancer_arn = aws_lb.payments_lb[each.value].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.payments_tg[each.value].arn
  }
}


resource "aws_ecs_task_definition" "payments-service" {
  for_each                 = var.environments
  family                   = "payments-service-${each.value}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
  task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
  container_definitions = jsonencode([
    {
      name  = "payments-service-${each.value}"
      image = "gr2001/payments-service-${each.value}:latest"
      environment = [
        {
          "" : ""
        }
      ]
      essential = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/payments-service-${each.value}"
          awslogs-region        = "us-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "payments-develop" {
  for_each                           = var.environments
  name                               = "payments-service-${each.value}"
  cluster                            = aws_ecs_cluster.cluster[each.value].id
  task_definition                    = aws_ecs_task_definition.payments-service[each.value].arn
  desired_count                      = "2"
  deployment_minimum_healthy_percent = "50"
  deployment_maximum_percent         = "100"
  enable_ecs_managed_tags            = true # It will tag the network interface with service name
  launch_type                        = "FARGATE"

  force_new_deployment = true

  network_configuration {
    subnets          = [var.subnet1, var.subnet2]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.payments_tg[each.value].arn
    container_name   = "payments-service-${each.value}"
    container_port   = 8080
  }
  depends_on = [
    aws_ecs_task_definition.payments-service
  ]
}