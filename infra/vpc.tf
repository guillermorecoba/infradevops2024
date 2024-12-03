variable "environment" {
  default = "develop"
}

resource "aws_vpc" "main" {
 cidr_block           = "10.0.0.0/16"
 enable_dns_hostnames = true
 tags = {
   name = var.environment
 }
}

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     name = "${var.environment}-igw"
#   }
# }

resource "aws_subnet" "subnet" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1a" 
}

resource "aws_subnet" "subnet2" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1b"
}

resource "aws_security_group" "load-balancer-ingress-security-group" {
    name        = "load-balancer-ingress-security-group"
    vpc_id      = aws_vpc.main.id
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
    name        = "alb-to-container-security-group"
    vpc_id      = aws_vpc.main.id
    ingress {
         from_port   = 0
         to_port     = 0
         protocol    = -1
         #PREGUNTAR A PROFE POR ESTO
        # from_port   = 8083
        # to_port     = 8083
        # protocol    = "tcp"
        security_groups = [aws_security_group.load-balancer-ingress-security-group.id]
    }
}

# resource "aws_lb" "load-balancer-shipping-service" {
#   name               = "load-balancer-shipping-service"
#   load_balancer_type               = "application"
#   subnets           = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
#   security_groups    = [aws_security_group.load-balancer-ingress-security-group.id] 
#   enable_deletion_protection = false
#   tags = {
#     Environment = var.environment
#   }
# }
# #LOAD BALANCER
# resource "aws_lb_target_group" "test" {
#   name     = "lb-shipping-service-${var.environment}"
#   port     = 8080
#   target_type = "ip"
#   protocol = "HTTP"  # Changed from "TCP" to "HTTP"
#   vpc_id   = aws_vpc.main.id
# }

# resource "aws_lb_listener" "load-balancer-listener-shipping-service" {
#   load_balancer_arn = aws_lb.load-balancer-shipping-service.arn
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.test.arn
#   }
# }
#END LOAD BALANCER
