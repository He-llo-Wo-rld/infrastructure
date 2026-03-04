# IAM Roles & Policies
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# Backend EC2 uses IAM Role (not static credentials) to access S3.

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Backend can read/write/delete objects ONLY in our bucket
data "aws_iam_policy_document" "s3_access" {
  statement {
    sid = "AllowS3UserImages"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.user_images.arn,
      "${aws_s3_bucket.user_images.arn}/*",
    ]
  }
}

resource "aws_iam_role" "backend" {
  name               = "${var.project_name}-backend-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.project_name}-backend-role"
  }
}

resource "aws_iam_role_policy" "backend_s3" {
  name   = "${var.project_name}-backend-s3-policy"
  role   = aws_iam_role.backend.id
  policy = data.aws_iam_policy_document.s3_access.json
}

# Instance Profile wrapper — EC2 cannot use IAM Role directly
resource "aws_iam_instance_profile" "backend" {
  name = "${var.project_name}-backend-profile"
  role = aws_iam_role.backend.name
}
