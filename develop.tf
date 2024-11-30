resource "aws_ecs_cluster" "develop" {
    name = "dev_cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "example" {
    
    family = "shipping-service"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
    memory                   = 512
    execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
    task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
    container_definitions = jsonencode([
        {
            name      = "shipping-service-dev"
            image     = "gr2001/shipping-service:latest"
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
            # logConfiguration = {
            #     logDriver = ""
            #     options   = {
            #         awslogs-create-group  = ""
            #         awslogs-group         = ""
            #         awslogs-region        = ""
            #         awslogs-stream-prefix = ""
            #     }
            # }
        }
    ])
    
    runtime_platform {
        # cpu_architecture = ""
        operating_system_family = "LINUX"
    }
}

# resource "aws_ecs_service" "develop" {
#     name                               = ""
#     cluster                            = ""
#     task_definition                    = ""
#     desired_count                      = ""
#     deployment_minimum_healthy_percent = ""
#     deployment_maximum_percent         = ""
#     launch_type                        = ""
#     scheduling_strategy                = ""
    
#     force_new_deployment = ""

#     network_configuration {
#         subnets         = ""
#         security_groups = ""
#         assign_public_ip = ""
#     }
    
#     load_balancer {
#         target_group_arn = ""
#         container_name   = ""
#         container_port   = ""
#     }

#     depends_on = [
#         aws_ecs_task_definition.example
#     ]
# }
