variable "environments" {
  default = {
    develop = "develop"
    staging = "staging"
    main    = "main"
  }
}

variable "subnet1" {
  default = "subnet-0c83d89ef3025830f"
}
variable "subnet2" {
  default = "subnet-06b7e9822001bf09e"
}
variable "vpc" {
  default = "vpc-055225dfe440522a7"
}

resource "aws_security_group" "load-balancer-ingress-security-group" {
  name   = "load-balancer-security-group"
  vpc_id = var.vpc
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb-to-container-security-group" {
  name   = "alb-to-container-security-group"
  vpc_id = var.vpc
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.load-balancer-ingress-security-group.id]
  }
}

resource "aws_ecs_cluster" "cluster" {
  for_each = var.environments
  name     = "cluster-${each.value}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
