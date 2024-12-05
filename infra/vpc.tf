variable "environment" {
  default = {
    "develop" = "develop"
    "main" = "main"
    "staging" = "staging"
  }
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

# resource "aws_ecs_cluster" "main" {
#   name = "${var.environment}_cluster"
#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }
# }
resource "aws_ecs_cluster" "clusters" {
  for_each = var.environment

  name = "${each.value}_cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
