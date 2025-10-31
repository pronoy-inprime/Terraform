# terraform/outputs.tf

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.cluster_01_inprime.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.nginx_fargate_svc.name
}
