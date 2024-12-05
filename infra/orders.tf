# resource "aws_lb_target_group" "tg-orders" {
#   name        = "tg-orders-${var.environment}"
#   port        = 8080
#   target_type = "ip"
#   protocol    = "HTTP" # Changed from "TCP" to "HTTP"
#   vpc_id      = var.vpc
# }


# resource "aws_lb_listener_rule" "listener_orders" {
#   listener_arn = aws_lb_listener.lbl-services.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg-orders.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/orders/*"]
#     }
#   }
# }

# resource "aws_ecs_task_definition" "orders-service" {

#   family                   = "orders-service-${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
#   task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
#   container_definitions = jsonencode([
#     {
#       name  = "orders-service-${var.environment}"
#       image = "gr2001/orders-service-${var.environment}:latest"
#       environment = [
#         {
#           "" : ""
#         }
#       ]
#       essential = true
#       portMappings = [
#         {
#           protocol      = "tcp"
#           containerPort = 8080
#         }
#       ]
#     }
#   ])
#   runtime_platform {
#     operating_system_family = "LINUX"
#   }
# }
# resource "aws_ecs_service" "orders" {
#   name                               = "orders-service-${var.environment}"
#   cluster                            = aws_ecs_cluster.main.id
#   task_definition                    = aws_ecs_task_definition.orders-service.arn
#   desired_count                      = "2"
#   deployment_minimum_healthy_percent = "50"
#   deployment_maximum_percent         = "100"
#   launch_type                        = "FARGATE"

#   force_new_deployment = true

#   network_configuration {
#     subnets          = [var.subnet1, var.subnet2]
#     assign_public_ip = true
#   }
#   load_balancer {
#     target_group_arn = aws_lb_target_group.tg-orders.arn
#     container_name   = "orders-service-${var.environment}"
#     container_port   = 8080
#   }
#   depends_on = [
#     aws_ecs_task_definition.orders-service
#   ]
# }
