resource "aws_ecs_cluster" "main" {
    name = "${var.enviroment}_cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "shipping-service" {
    
    family = "shipping-service-${var.enviroment}"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
    memory                   = 512
    container_definitions = jsonencode([
        {
            name      = "shipping-service-${var.enviroment}"
            image     = "gr2001/shipping-service-${var.enviroment}:latest"
            environment = [
                {
                "" : ""
                }
            ]
            essential = true
            portMappings = [
                {
                protocol      = "tcp"
                containerPort = 8083
                }
            ]
            logConfiguration = {
                logDriver = ""
                options   = {
                    awslogs-create-group  = ""
                    awslogs-group         = ""
                    awslogs-region        = ""
                    awslogs-stream-prefix = ""
                }
            }
        }
    ])
    
    runtime_platform {
        operating_system_family = "LINUX"
    }
}

resource "aws_ecs_service" "develop" { 
    name                               = "${var.enviroment}-service"
    cluster                            = aws_ecs_cluster.main.id
    task_definition                    = aws_ecs_task_definition.shipping-service.arn
    desired_count                      = "2"
    deployment_minimum_healthy_percent = "1"
    deployment_maximum_percent         = "2"
    launch_type                        = "FARGATE"
    
    force_new_deployment = true

    network_configuration {
        subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
        security_groups = [aws_security_group.alb-to-container-security-group.id]
    }
    
    load_balancer {
        target_group_arn =  aws_lb_target_group.test.arn
        container_name   = "shipping-service-${var.enviroment}"
        container_port   = 8083
    }

    depends_on = [
        aws_ecs_task_definition.shipping-service
    ]
}
