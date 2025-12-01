 # Custom Aurora PostgreSQL Parameter Group
resource "aws_rds_cluster_parameter_group" "custom_aurora_pg" {
  family      = "aurora-postgresql17"
  name        = "custom-aurora-postgresql17"
  description = "Custom parameter group for Aurora PostgreSQL 17"

  # Example parameters you might want to customize can be added here 
  # (learn about static parameters that can only be added after creation or after restart of db instances)

  tags = {
    Name = "custom-aurora-postgresql17"
  }
}

# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "test_database" {
  cluster_identifier             = "test-database"
  engine                         = "aurora-postgresql"
  engine_version                 = "17.4"
  database_name                  = "postgres"
  master_username                = "postgres"
  master_password                = "pronoy123"
  
  # Network Configuration
  db_subnet_group_name           = var.subnetgrp1dev_name
  vpc_security_group_ids         = [
    var.sg_alb_id, var.sg_01_id
  ]
  port                          = 5432
  network_type                  = "IPV4"
  
  # Storage Configuration
  storage_encrypted             = true
  # kms_key_id                   = "arn:aws:kms:ap-south-2:763790537059:key/7c099364-a9f2-417b-bcac-b9fdc717cf77"
  
  # Serverless v2 Configuration
  serverlessv2_scaling_configuration {
    max_capacity = 2
    min_capacity = 0.5
  }
  
  # Backup Configuration
  backup_retention_period       = 7
  preferred_backup_window       = "12:18-12:48"
  preferred_maintenance_window  = "sun:00:00-sun:00:30"
  
  # Parameter Group
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.custom_aurora_pg.name

  # Additional Settings
  # auto_minor_version_upgrade    = true
  deletion_protection          = false
  iam_database_authentication_enabled = false
  
  # Skip final snapshot for easier cleanup (adjust as needed)
  skip_final_snapshot          = true
  
  tags = {
    Name        = "test-database"
    Environment = "dev"
  }
}

# Aurora PostgreSQL Instance (Primary)
resource "aws_rds_cluster_instance" "test_database_instance" {
  identifier              = "test-database-instance-1"
  cluster_identifier      = aws_rds_cluster.test_database.id
  instance_class          = "db.serverless"  # For Serverless v2
  engine                  = aws_rds_cluster.test_database.engine
  engine_version          = aws_rds_cluster.test_database.engine_version
  
  # Performance Insights
  performance_insights_enabled = false
  
  # Monitoring
  monitoring_interval     = 0
  
  tags = {
    Name        = "test-database-instance-1"
    Environment = "dev"
  }
}
