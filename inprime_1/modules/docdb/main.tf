resource "aws_docdb_subnet_group" "subnet_grp_1_dev" {
  name       = "subnet-grp-1-dev"
  subnet_ids = [
    var.private_subnet_01_vpc01,
    var.private_subnet_02_vpc01,
  ]
  description = "test"

  tags = {
    Name = "subnet-grp-1-dev"
  }
}

resource "aws_docdb_cluster_parameter_group" "test_clusterdocdb" {
  family      = "docdb5.0"
  name        = "test-clusterdocdb"
  description = "not"

  # Since all parameters are using system defaults, you don't need to explicitly set them
  # However, if you want to explicitly define the current values, you can include:
  
  parameter {
    name  = "audit_logs"
    value = "disabled"
  }

  parameter {
    name  = "change_stream_log_retention_duration"
    value = "10800"
  }

  parameter {
    name  = "default_collection_compression"
    value = "disabled"
  }

  parameter {
    name  = "planner_version"
    value = "1.0"
  }

  parameter {
    name  = "profiler"
    value = "disabled"
  }

  parameter {
    name  = "profiler_sampling_rate"
    value = "1.0"
  }

  parameter {
    name  = "profiler_threshold_ms"
    value = "100"
  }

  parameter {
    name  = "tls"
    value = "enabled"
  }

  parameter {
    name  = "ttl_monitor"
    value = "enabled"
  }

  tags = {
    Name = "test-clusterdocdb"
  }
}

# Security Group for DocumentDB
resource "aws_security_group" "docdb_sg" {
  name_prefix = "docdb-sg-"
  description = "Security group for DocumentDB cluster"
  vpc_id      = var.vpc_id  # Reference to your VPC

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]  # Allow access from VPC CIDR
    description = "DocumentDB port access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "docdb-security-group"
  }
}

# DocumentDB Cluster
resource "aws_docdb_cluster" "test_docdb" {
  cluster_identifier      = "test-docdb"
  engine                 = "docdb"
  engine_version         = "5.0.0"
  master_username        = "pronoy"
  master_password        = "pronoy123"  # You'll need to provide this as a variable
  
  # Serverless configuration
  serverless_v2_scaling_configuration {
    min_capacity = 2
    max_capacity = 4
  }
  
  # Network configuration
  db_subnet_group_name   = aws_docdb_subnet_group.subnet_grp_1_dev.name
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
  port                   = 27017
  
  # Parameter group
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.test_clusterdocdb.name
  
  # Storage
  storage_type = "standard"
  
  # Encryption
  storage_encrypted = true
  # kms_key_id       = "alias/aws/rds"  # Default AWS managed key
  
  # Backup configuration
  backup_retention_period = 1
  preferred_backup_window = "00:00-00:30"  # 12:00 AM to 12:30 AM UTC
  
  # Maintenance window (optional - you can adjust as needed)
  preferred_maintenance_window = "sun:03:00-sun:04:00"
  
  # Deletion protection
  deletion_protection = false
  
  # Skip final snapshot for easier deletion
  skip_final_snapshot = true
  
  # No log exports as requested
  enabled_cloudwatch_logs_exports = []
  
  tags = {
    Name = "test-docdb"
  }
  
  depends_on = [
    aws_docdb_cluster_parameter_group.test_clusterdocdb,
    aws_docdb_subnet_group.subnet_grp_1_dev
  ]
}

# dont need we are using serverless
# DocumentDB Cluster Instances (3 regular replicas)
# resource "aws_docdb_cluster_instance" "docdb_instances" {
#   count              = 3
#   identifier         = "test-docdb-${count.index + 1}"
#   cluster_identifier = aws_docdb_cluster.test_docdb.id
#   instance_class     = "db.t4g.medium"  # Adjust instance class as needed
  
#   tags = {
#     Name = "test-docdb-instance-${count.index + 1}"
#   }
# }
