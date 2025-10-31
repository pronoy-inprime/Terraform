# resource "aws_lb" "alb_vpc01" {
#   name               = "alb-vpc01"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [var.sg_alb_id]
#   subnets            = [var.public_subnet_01_vpc01_id, var.public_subnet_02_vpc01_id]

#   tags = {
#     Environment = "alb_vpc01"
#   }
# }

# resource "aws_lb_listener" "istener" {
#   load_balancer_arn = aws_lb.alb_vpc01.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_grp.arn
#   }
# }

# resource "aws_lb_target_group" "target_grp" {
#   name     = "target-grp"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc_inprime_01_id
# }
# resource "aws_lb_target_group_attachment" "tg_a" {
#   count = length(var.ec2)
#   target_group_arn = aws_lb_target_group.target_grp.arn
#   target_id        = var.ec2[count.index]
#   port             = 80
# }

# Application Load Balancer
resource "aws_lb" "alb_vpc01" {
  name               = "alb-vpc01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  subnets            = [var.public_subnet_01_vpc01_id, var.public_subnet_02_vpc01_id]

  tags = {
    Name = "alb_vpc01"
  }
}

# Target Group
resource "aws_lb_target_group" "ecs_cluster" {
  name        = "ecs-cluster"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_inprime_01_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ecs-cluster"
  }
}

# ALB Listener
resource "aws_lb_listener" "alb_vpc01_listener" {
  load_balancer_arn = aws_lb.alb_vpc01.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_cluster.arn
  }
}