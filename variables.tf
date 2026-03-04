# Input Variables
# Docs: https://developer.hashicorp.com/terraform/language/values/variables
# Values are set in terraform.tfvars (copy from terraform.tfvars.example)

# --- General ---

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name (used in resource naming)"
  type        = string
  default     = "quizapp"
}

# --- Network ---

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_a_cidr" {
  description = "Private subnet A CIDR (RDS primary)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_b_cidr" {
  description = "Private subnet B CIDR (RDS requires 2 AZs)"
  type        = string
  default     = "10.0.3.0/24"
}

# --- EC2 ---

variable "ec2_instance_type" {
  description = "EC2 instance type (t2.micro = Free Tier)"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "SSH key pair name"
  type        = string
  default     = "quizapp-key"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/quizapp-key.pub"
}

variable "my_ip" {
  description = "Your IP address for SSH access (format: x.x.x.x/32)"
  type        = string
}

# --- RDS ---

variable "db_instance_class" {
  description = "RDS instance class (db.t3.micro = Free Tier)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "quizapp"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "quizapp"
}

variable "db_password" {
  description = "Database password (min 8 characters)"
  type        = string
  sensitive   = true
}

# --- S3 ---

variable "s3_bucket_name" {
  description = "S3 bucket name for user images (must be globally unique)"
  type        = string
}

variable "backend_port" {
  description = "Порт backend додатку"
  type        = number
  default     = 8000
}

variable "frontend_port" {
  description = "Порт frontend додатку"
  type        = number
  default     = 3000
}
