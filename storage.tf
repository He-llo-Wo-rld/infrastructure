# S3 Bucket (user image storage)
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# Free Tier: 5GB, 20k GET, 2k PUT/month (first year)

resource "aws_s3_bucket" "user_images" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "${var.project_name}-user-images"
  }
}

# Block all public access — images served via backend presigned URLs
resource "aws_s3_bucket_public_access_block" "user_images" {
  bucket = aws_s3_bucket.user_images.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "user_images" {
  bucket = aws_s3_bucket.user_images.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "user_images" {
  bucket = aws_s3_bucket.user_images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "user_images" {
  bucket = aws_s3_bucket.user_images.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["https://quizapp-serhii.duckdns.org"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
  }
}
