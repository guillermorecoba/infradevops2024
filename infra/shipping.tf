resource "aws_lb" "dev_shipping_lb" {
  name               = "dev-shipping-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer-ingress-security-group.id]
  subnets            = [var.subnet1, var.subnet2]
  tags = {
    Name = "dev-shipping-lb"
  }
}

resource "aws_lb_target_group" "dev_shipping_tg" {
  name        = "dev-shipping-tg"
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
    Name = "dev-shipping-tg"
  }
}

resource "aws_lb_listener" "dev_shipping_listener" {
  load_balancer_arn = aws_lb.dev_shipping_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_shipping_tg.arn
  }
}


resource "aws_ecs_task_definition" "shipping-service-develop" {

  family                   = "shipping-service-develop"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
  task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
  container_definitions = jsonencode([
    {
      name  = "shipping-service-develop"
      image = "gr2001/shipping-service-develop:latest"
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
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "shipping-develop" {
  name                               = "shipping-service-develop"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.shipping-service-develop.arn
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
    target_group_arn = aws_lb_target_group.dev_shipping_tg.arn
    container_name   = "shipping-service-develop"
    container_port   = 8080
  }
  depends_on = [
    aws_ecs_task_definition.shipping-service-develop
  ]
}