output "docdb_cluster_endpoint" {
  description = "DocumentDB cluster endpoint"
  value       = aws_docdb_cluster.test_docdb.endpoint
}

output "docdb_cluster_reader_endpoint" {
  description = "DocumentDB cluster reader endpoint"
  value       = aws_docdb_cluster.test_docdb.reader_endpoint
}

output "docdb_cluster_port" {
  description = "DocumentDB cluster port"
  value       = aws_docdb_cluster.test_docdb.port
}

output "docdb_cluster_id" {
  description = "DocumentDB cluster identifier"
  value       = aws_docdb_cluster.test_docdb.id
}

output "docdb_security_group_id" {
  description = "Security Group ID for DocumentDB"
  value       = aws_security_group.docdb_sg.id
}

output "master_user_secret_arn" {
  description = "ARN of the master user secret in Secrets Manager"
  value = "dummy"
#   value       = var.manage_master_user_password ? aws_docdb_cluster.docdb_cluster.master_user_secret[0].secret_arn : null
}

output "aws_docdb_subnet_group_name" {
  description = "DocumentDB Subnet Group Name"
  value       = aws_docdb_subnet_group.subnet_grp_1_dev.name
}