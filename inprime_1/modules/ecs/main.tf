# ECS Cluster
resource "aws_ecs_cluster" "cluster_01_inprime" {
  name = "cluster_01_inprime"

  tags = {
    Name = "cluster_01_inprime"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "nginx_fargate_task" {
  family                   = "nginx_fargate_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "nginx-latest"
      image = "docker.io/nginx:latest"
      
      portMappings = [
        {
          name          = "nginx-80-tcp"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      essential = true
    }
  ])

  tags = {
    Name = "nginx_fargate_task"
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Service
resource "aws_ecs_service" "nginx_fargate_svc" {
  name            = "nginx_fargate_svc"
  cluster         = aws_ecs_cluster.cluster_01_inprime.id
  task_definition = aws_ecs_task_definition.nginx_fargate_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = [var.private_subnet_01_vpc01_id]
    security_groups  = [var.sg_01_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.tgt_grp_ecs_cluster_arn
    container_name   = "nginx-latest"
    container_port   = 80
  }

  deployment_circuit_breaker {
      enable   = true
      rollback = true
    }

  enable_ecs_managed_tags = true

  depends_on = [var.alb_vpc01_listener_arn]

  tags = {
    Name = "nginx_fargate_svc"
  }
}
