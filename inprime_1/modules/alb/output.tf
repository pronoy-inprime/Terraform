output "tgt_grp_ecs_cluster_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.ecs_cluster.arn
}
output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.alb_vpc01.dns_name
}
output "alb_zone_id" {
  description = "The zone ID of the load balancer"
  value       = aws_lb.alb_vpc01.zone_id
}
output "alb_vpc01_listener_arn" {
    description = "ARN of the ALB listener"
    value       = aws_lb_listener.alb_vpc01_listener.arn
}