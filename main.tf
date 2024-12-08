resource "aws_ecs_cluster" "main" {
    name = ""

    setting {
        name  = ""
        value = ""
    }
}

resource "aws_ecs_task_definition" "example" {
    
    family = ""
    network_mode             = ""
    requires_compatibilities = [""]
    cpu                      = ""
    memory                   = ""
    execution_role_arn       = ""
    task_role_arn            = ""
    container_definitions = jsonencode([
        {
            name      = ""
            image     = ""
            environment = [
                {
                "" : ""
                }
            ]
            essential = ""
            portMappings = [
                {
                protocol = ""
                containerPort = ""
                hostPort      = ""
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
        cpu_architecture = ""
        operating_system_family = ""
    }
}

resource "aws_ecs_service" "main" {
    name                               = ""
    cluster                            = ""
    task_definition                    = ""
    desired_count                      = ""
    deployment_minimum_healthy_percent = ""
    deployment_maximum_percent         = ""
    launch_type                        = ""
    scheduling_strategy                = ""
    
    force_new_deployment = ""

    network_configuration {
        subnets         = ""
        security_groups = ""
        assign_public_ip = ""
    }
    
    load_balancer {
        target_group_arn = ""
        container_name   = ""
        container_port   = ""
    }

    depends_on = [
        aws_ecs_task_definition.example
    ]
}
