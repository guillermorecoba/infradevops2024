resource "aws_ecs_task_definition" "products-service" {

  family                   = "products-service-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::975050210892:role/LabRole"
  task_role_arn            = "arn:aws:iam::975050210892:role/LabRole"
  container_definitions = jsonencode([
    {
      name  = "products-service-${var.environment}"
      image = "gr2001/products-service-${var.environment}:latest"
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
  name                               = "products-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.products-service.arn
  desired_count                      = "2"
  deployment_minimum_healthy_percent = "50"
  deployment_maximum_percent         = "100"
  launch_type                        = "FARGATE"

  force_new_deployment = true
    network_configuration {
    subnets          = [var.subnet1, var.subnet2]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.products-service
  ]
}