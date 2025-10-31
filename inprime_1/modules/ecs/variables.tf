variable "private_subnet_01_vpc01_id" {
    description =  "VPC Private Subnet 01 Cidr ID"
    type = string  
}

variable "tgt_grp_ecs_cluster_arn" {   
    description = "ARN of the target group"
    type = string
}
variable "sg_01_id" {
    description = "Security Group for ECS Service"
    type = string
}
variable "alb_vpc01_listener_arn" {
    description = "ARN of the ALB listener"
    type = string
}