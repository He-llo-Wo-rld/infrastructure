# Security Groups
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
#
# Each resource has its own SG with least-privilege access.
# Backend is reachable ONLY from Frontend; RDS ONLY from Backend.

# ── Frontend Security Group ──

resource "aws_security_group" "frontend" {
  name_prefix = "${var.project_name}-frontend-"
  description = "Security group for frontend EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from anywhere (redirects to HTTPS via Nginx)"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from anywhere"
  }

  ingress {
    from_port   = var.frontend_port
    to_port     = var.frontend_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Next.js direct access"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
    description = "SSH from my IP only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "${var.project_name}-frontend-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ── Backend Security Group ──

resource "aws_security_group" "backend" {
  name_prefix = "${var.project_name}-backend-"
  description = "Security group for backend EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.backend_port
    to_port         = var.backend_port
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
    description     = "API access from frontend only"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
    description = "SSH from my IP only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound (Auth0, SMTP, Docker Hub)"
  }

  tags = {
    Name = "${var.project_name}-backend-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ── RDS Security Group ──

resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-rds-"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
    description     = "PostgreSQL from backend only"
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}
