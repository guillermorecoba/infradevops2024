#DEV
resource "aws_lb" "develop_payments_lb" {
  name               = "develop-payments-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer-ingress-security-group.id]
  subnets            = [var.subnet1, var.subnet2]
  tags = {
    Name = "develop-payments-lb"
  }
}


resource "aws_lb_target_group" "develop_payments_tg" {
  name        = "tg-payments-${var.environment}"
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

resource "aws_lb_listener" "develop_payments_lb" {
  load_balancer_arn = aws_lb.develop_payments_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.develop_payments_tg.arn
  }
}


resource "aws_ecs_task_definition" "payments-service-develop" {

  family                   = "payments-service-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
  task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
  container_definitions = jsonencode([
    {
      name  = "payments-service-develop"
      image = "gr2001/payments-service-develop:latest"
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
          awslogs-group         = "/ecs/payments-service-develop"
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
  name                               = "payments-service-develop"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.payments-service-develop.arn
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
    target_group_arn = aws_lb_target_group.develop_payments_tg.arn
    container_name   = "payments-service-develop"
    container_port   = 8080
  }
  depends_on = [
    aws_ecs_task_definition.payments-service-develop
  ]
}