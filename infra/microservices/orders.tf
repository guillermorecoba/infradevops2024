resource "aws_lb" "orders_lb" {
  for_each           = var.environments
  name               = "orders-lb-${each.value}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer-ingress-security-group.id]
  subnets            = [var.subnet1, var.subnet2]
  tags = {
    Name = "orders-lb-${each.value}"
  }
}

resource "aws_lb_target_group" "orders_tg" {
  for_each = var.environments

  name        = "orders-tg-${each.value}"
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
    Name = "orders-tg-${each.value}"
  }
  depends_on = [
    aws_lb.orders_lb
  ]
}

resource "aws_lb_listener" "orders_listener" {
  for_each          = var.environments
  load_balancer_arn = aws_lb.orders_lb[each.value].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.orders_tg[each.value].arn
  }
  depends_on = [
    aws_lb.orders_lb,
    aws_lb_target_group.orders_tg
  ]
}



resource "aws_ecs_task_definition" "orders-service" {
  for_each                 = var.environments
  family                   = "orders-service-${each.value}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
  task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
  container_definitions = jsonencode([
    {
      name  = "orders-service-${each.value}"
      image = "gr2001/orders-service-${each.value}:latest"
      environment = [
        {
          name = "APP_ARGS"
          value = join(" ", [aws_lb.payments_lb[each.value].dns_name,
            aws_lb.shipping_lb[each.value].dns_name,
          aws_lb.products_lb[each.value].dns_name])
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
    aws_lb.orders_lb,
    aws_lb_target_group.orders_tg,
    aws_lb_listener.orders_listener,
    aws_lb.payments_lb,
    aws_lb.shipping_lb,
    aws_lb.products_lb
  ]

  tags = {
    Name = join(" ", [aws_lb.payments_lb[each.value].dns_name, aws_lb.shipping_lb[each.value].dns_name, aws_lb.products_lb[each.value].dns_name])
  }

}
resource "aws_ecs_service" "orders-develop" {
  for_each                           = var.environments
  name                               = "orders-service-${each.value}"
  cluster                            = aws_ecs_cluster.cluster[each.value].id
  task_definition                    = aws_ecs_task_definition.orders-service[each.value].arn
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
    target_group_arn = aws_lb_target_group.orders_tg[each.value].arn
    container_name   = "orders-service-${each.value}"
    container_port   = 8080
  }
  depends_on = [
    aws_ecs_task_definition.orders-service,
    aws_lb.orders_lb,
    aws_lb_target_group.orders_tg,
    aws_lb_listener.orders_listener
  ]
}
