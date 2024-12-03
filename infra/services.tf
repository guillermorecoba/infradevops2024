#SECURITY GROUPS

#END SECURITY GROUP



#CLUSTER ECS
resource "aws_ecs_cluster" "main" {
    name = "${var.environment}_cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# resource "aws_ecs_service" "shipping" { 
#     name                               = "shipping-service-${var.environment}"
#     cluster                            = aws_ecs_cluster.main.id
#     task_definition                    = aws_ecs_task_definition.shipping-service.arn
#     desired_count                      = "2"
#     deployment_minimum_healthy_percent = "50"
#     deployment_maximum_percent         = "100"
#     launch_type                        = "FARGATE"
#     # scheduling_strategy                = ""
    
#     force_new_deployment = true

#     network_configuration {
#         subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
#         assign_public_ip = false
#     }
#     depends_on = [
#         aws_ecs_task_definition.shipping-service
#     ]
# }

# resource "aws_ecs_service" "products" { 
#     name                               = "products-service-${var.environment}"
#     cluster                            = aws_ecs_cluster.main.id
#     task_definition                    = aws_ecs_task_definition.products-service.arn
#     desired_count                      = "2"
#     deployment_minimum_healthy_percent = "50"
#     deployment_maximum_percent         = "100"
#     launch_type                        = "FARGATE"
#     # scheduling_strategy                = ""
    
#     force_new_deployment = true

#     network_configuration {
#         subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
#         assign_public_ip = false
#     }
#     depends_on = [
#         aws_ecs_task_definition.products-service
#     ]
# }
# resource "aws_ecs_service" "orders" { 
#     name                               = "orders-service-${var.environment}"
#     cluster                            = aws_ecs_cluster.main.id
#     task_definition                    = aws_ecs_task_definition.orders-service.arn
#     desired_count                      = "2"
#     deployment_minimum_healthy_percent = "50"
#     deployment_maximum_percent         = "100"
#     launch_type                        = "FARGATE"
    
#     force_new_deployment = true

#     network_configuration {
#         subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
#         assign_public_ip = false
#     }
#     depends_on = [
#         aws_ecs_task_definition.orders-service
#     ]
# }

resource "aws_ecs_service" "payments" { 
    name                               = "payments-service-${var.environment}"
    cluster                            = aws_ecs_cluster.main.id
    task_definition                    = aws_ecs_task_definition.payments-service.arn
    desired_count                      = "2"
    deployment_minimum_healthy_percent = "50"
    deployment_maximum_percent         = "100"
    launch_type                        = "FARGATE"
    
    force_new_deployment = true

    network_configuration {
        subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
        assign_public_ip = false
    }
    depends_on = [
        aws_ecs_task_definition.payments-service
    ]
}
