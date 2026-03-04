# Outputs
# Docs: https://developer.hashicorp.com/terraform/language/values/outputs

output "frontend_public_ip" {
  description = "Frontend Elastic IP"
  value       = aws_eip.frontend.public_ip
}

output "frontend_public_dns" {
  description = "Frontend EC2 public DNS"
  value       = aws_instance.frontend.public_dns
}

output "backend_public_ip" {
  description = "Backend Elastic IP (SSH only)"
  value       = aws_eip.backend.public_ip
}

output "backend_private_ip" {
  description = "Backend private IP (frontend-to-backend communication)"
  value       = aws_instance.backend.private_ip
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint (host:port)"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "RDS PostgreSQL address (host only)"
  value       = aws_db_instance.postgres.address
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.user_images.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.user_images.arn
}

output "ssh_frontend" {
  description = "SSH command for frontend EC2"
  value       = "ssh -i ~/.ssh/${var.key_pair_name} ec2-user@${aws_eip.frontend.public_ip}"
}

output "ssh_backend" {
  description = "SSH command for backend EC2"
  value       = "ssh -i ~/.ssh/${var.key_pair_name} ec2-user@${aws_eip.backend.public_ip}"
}

output "app_url" {
  description = "Application URL"
  value       = "https://quizapp-serhii.duckdns.org"
}

output "backend_env_hint" {
  description = "Environment variables for backend .env"
  value = <<-EOT
    POSTGRES_HOST=${aws_db_instance.postgres.address}
    POSTGRES_PORT=5432
    POSTGRES_DB=${var.db_name}
    POSTGRES_USER=${var.db_username}
    REDIS_HOST=redis
    REDIS_PORT=6379
  EOT
}
