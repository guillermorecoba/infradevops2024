resource "aws_lb" "shipping_lb" {
  for_each           = var.environments
  name               = "shipping-lb-${each.value}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer-ingress-security-group.id]
  subnets            = [var.subnet1, var.subnet2]
  tags = {
    Name = "shipping-lb-${each.value}"
  }
}

resource "aws_lb_target_group" "shipping_tg" {
  for_each    = var.environments
  name        = "shipping-tg-${each.value}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200,404"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "shipping-tg-${each.value}"
  }
}

resource "aws_lb_listener" "shipping_listener" {
  for_each          = var.environments
  load_balancer_arn = aws_lb.shipping_lb[each.value].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shipping_tg[each.value].arn
  }
}


resource "aws_ecs_task_definition" "shipping-service" {
  for_each = var.environments

  family                   = "shipping-service-${each.value}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
  task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
  container_definitions = jsonencode([
    {
      name      = "shipping-service-${each.value}"
      image     = "gr2001/shipping-service-${each.value}:latest"
      essential = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = 8080
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "shipping-service" {
  for_each = var.environments

  name                               = "shipping-service-${each.value}"
  cluster                            = aws_ecs_cluster.cluster[each.value].id
  task_definition                    = aws_ecs_task_definition.shipping-service[each.value].arn
  desired_count                      = "2"
  deployment_minimum_healthy_percent = "50"
  deployment_maximum_percent         = "100"
  launch_type                        = "FARGATE"
  enable_ecs_managed_tags            = true # It will tag the network interface with service name

  force_new_deployment = true

  network_configuration {
    subnets          = [var.subnet1, var.subnet2]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.shipping_tg[each.value].arn
    container_name   = "shipping-service-${each.value}"
    container_port   = 8080
  }
  depends_on = [
    aws_ecs_task_definition.shipping-service
  ]
}