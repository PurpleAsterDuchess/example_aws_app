resource "aws_db_instance" "demo_db_instance" {
    allocated_storage    = 5
    db_name              = var.aws_database
    engine               = "postgres"
    engine_version       = "17.6"
    instance_class       = "db.t3.micro"
    username             = "demo_admin"
    password             = "admin123"
    parameter_group_name = "default.postgres17"
    skip_final_snapshot  = true
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.demo_db_instance.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.demo_db_instance.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.demo_db_instance.username
  sensitive   = true
}
