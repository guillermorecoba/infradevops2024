resource "aws_lb" "dev_products_lb" {
  name               = "dev-products-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer-ingress-security-group.id]
  subnets            = [var.subnet1, var.subnet2]

  tags = {
    Name = "dev-products-lb"
  }
}

resource "aws_lb_target_group" "dev_products_tg" {
  name        = "dev-products-tg"
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
    Name = "dev-products-tg"
  }
}

resource "aws_lb_listener" "dev_products_listener" {
  load_balancer_arn = aws_lb.dev_products_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_products_tg.arn
  }
}

resource "aws_ecs_task_definition" "products-service-develop" {

  family                   = "products-service-develop"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
  task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
  container_definitions = jsonencode([
    {
      name  = "products-service-develop"
      image = "gr2001/products-service-develop:latest"
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
resource "aws_ecs_service" "products" {
  name                               = "products-service-develop"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.products-service-develop.arn
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
    target_group_arn = aws_lb_target_group.dev_products_tg.arn
    container_name   = "products-service-develop"
    container_port   = 8080
  }
  depends_on = [
    aws_ecs_task_definition.products-service-develop
  ]
}
