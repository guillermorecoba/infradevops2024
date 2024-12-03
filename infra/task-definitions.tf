resource "aws_ecs_task_definition" "shipping-service" {
    
    family = "shipping-service-${var.environment}"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
    memory                   = 512
    execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
    task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
    container_definitions = jsonencode([
        {
            name      = "shipping-service"
            image     = "public.ecr.aws/nginx/nginx:1.27-bookworm"
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
resource "aws_ecs_task_definition" "payments-service" {
    
    family = "payments-service-${var.environment}"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
    memory                   = 512
    execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
    task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
    container_definitions = jsonencode([
        {
            name      = "payments-service"
            image     = "public.ecr.aws/nginx/nginx:1.27-bookworm"
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
resource "aws_ecs_task_definition" "products-service" {
    
    family = "products-service-${var.environment}"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
    memory                   = 512
    execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
    task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
    container_definitions = jsonencode([
        {
            name      = "products-service"
            image     = "public.ecr.aws/nginx/nginx:1.27-bookworm"
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
resource "aws_ecs_task_definition" "orders-service" {
    
    family = "orders-service-${var.environment}"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
    memory                   = 512
    execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
    task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
    container_definitions = jsonencode([
        {
            name      = "orders-service"
            image     = "public.ecr.aws/nginx/nginx:1.27-bookworm"
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