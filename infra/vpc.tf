variable "environment" {
  default = "develop"
}

variable "services" {
  default = {
    "payments" = "gr2001/products-service"
    "shipping" = "gr2001/shipping-service"
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


# resource "aws_vpc" "main" {
#  cidr_block           = "10.0.0.0/16"
#  enable_dns_hostnames = true
#  tags = {
#    name = var.environment
#  }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     name = "${var.environment}-igw"
#   }
# }

# resource "aws_subnet" "subnet" {
#  vpc_id                  = aws_vpc.main.id
#  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
#  map_public_ip_on_launch = true
#  availability_zone       = "us-east-1a" 
# }

# resource "aws_subnet" "subnet2" {
#  vpc_id                  = aws_vpc.main.id
#  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
#  map_public_ip_on_launch = true
#  availability_zone       = "us-east-1b"
# }

resource "aws_security_group" "load-balancer-ingress-security-group" {
  name   = "load-balancer-ingress-security-group"
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

resource "aws_lb" "service-load-balancer" {
  name                       = "service-load-balancer"
  load_balancer_type         = "application"
  subnets                    = [var.subnet1, var.subnet2]
  security_groups            = [aws_security_group.load-balancer-ingress-security-group.id]
  enable_deletion_protection = false
  tags = {
    Environment = var.environment
  }
}
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}_cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
resource "aws_lb_listener" "lbl-services" {
  load_balancer_arn = aws_lb.service-load-balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}
resource "aws_lb_listener_rule" "products" {
  listener_arn = aws_lb_listener.lbl-services.arn
  priority     = 101

  condition {
    host_header {
      values = ["*.products.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-products.arn
  }
}
resource "aws_lb_listener_rule" "shipping" {
  listener_arn = aws_lb_listener.lbl-services.arn
  priority     = 100

  condition { 
  host_header {
    values = ["*.shipping.com"]
  }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-shipping.arn
  }
}
#LOAD BALANCER

#END LOAD BALANCER
