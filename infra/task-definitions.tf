# resource "aws_ecs_task_definition" "payments-service" {

#   family                   = "payments-service-${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
#   task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
#   container_definitions = jsonencode([
#     {
#       name  = "payments-service"
#       image = "gr2001/payments-service-${var.environment}:latest"
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
#       logConfiguration = {
#         logDriver = "awslogs"
#       }
#     }
#   ])

#   runtime_platform {
#     operating_system_family = "LINUX"
#   }
# }
# resource "aws_ecs_task_definition" "products-service" {

#   family                   = "products-service-${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
#   task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
#   container_definitions = jsonencode([
#     {
#       name  = "products-service"
#       image = "gr2001/products-service-${var.environment}:latest"
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
#       logConfiguration = {
#         logDriver = "awslogs"
#       }
#     }
#   ])

#   runtime_platform {
#     operating_system_family = "LINUX"
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
#       name  = "orders-service"
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
#       logConfiguration = {
#         logDriver = "awslogs"
#       }
#     }
#   ])

#   runtime_platform {
#     operating_system_family = "LINUX"
#   }
# }