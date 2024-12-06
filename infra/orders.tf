resource "aws_lb" "develop_orders_lb" {
  name               = "develop-orders-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer-ingress-security-group.id]
  subnets            = [var.subnet1, var.subnet2]
  tags = {
    Name = "develop-orders-lb"
  }
}

resource "aws_lb_target_group" "develop_orders_tg" {
  name        = "develop-orders-tg"
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
    Name = "develop-orders-tg"
  }
}

resource "aws_lb_listener" "develop_orders_listener" {
  load_balancer_arn = aws_lb.develop_orders_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.develop_orders_tg.arn
  }
}



resource "aws_ecs_task_definition" "orders-service-develop" {

  family                   = "orders-service-develop"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
  task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
  container_definitions = jsonencode([
    {
      name  = "orders-service-develop"
      image = "gr2001/orders-service-develop:latest"
      environment = [
        {
          name  = "APP_ARGS"
          value = join(" ", [aws_lb.develop_payments_lb.dns_name, aws_lb.dev_shipping_lb.dns_name, aws_lb.dev_products_lb.dns_name])
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
  depends_on = [
    aws_lb.develop_payments_lb,
    aws_lb.dev_shipping_lb,
    aws_lb.dev_products_lb
  ]

    tags = {
    Name = join(" ", [aws_lb.develop_payments_lb.dns_name, aws_lb.dev_shipping_lb.dns_name, aws_lb.dev_products_lb.dns_name])
  }
 
}
resource "aws_ecs_service" "orders-develop" {
  name                               = "orders-service-develop"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.orders-service-develop.arn
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
    target_group_arn = aws_lb_target_group.develop_orders_tg.arn
    container_name   = "orders-service-develop"
    container_port   = 8080
  }
  depends_on = [
    aws_ecs_task_definition.orders-service-develop
  ]
}
