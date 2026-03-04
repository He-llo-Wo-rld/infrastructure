# EC2 Instances & Elastic IPs
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# Free Tier: 750 hours t2.micro/month (first year)
# Note: 2 EC2 running 24/7 = ~1440 hours > 750 Free Tier limit

# ── SSH Key Pair ──

resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = file(var.ssh_public_key_path)

  tags = {
    Name = "${var.project_name}-key"
  }
}

# ── EC2 Frontend ──
# Runs: Nginx (SSL termination :443) → Docker Next.js (:3000)

resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.main.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.frontend.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = file("${path.module}/scripts/setup-frontend.sh")

  tags = {
    Name = "${var.project_name}-frontend"
    Role = "frontend"
  }
}

# ── EC2 Backend ──
# Runs: Docker FastAPI (:8000) + Docker Redis (:6379)

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.main.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.backend.id]
  iam_instance_profile   = aws_iam_instance_profile.backend.name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = file("${path.module}/scripts/setup-backend.sh")

  tags = {
    Name = "${var.project_name}-backend"
    Role = "backend"
  }
}

# ── Elastic IPs ──
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# Static public IPs that persist across EC2 stop/start.
# Free while attached to a RUNNING instance; $0.005/hr when stopped.

resource "aws_eip" "frontend" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-frontend-eip"
  }
}

resource "aws_eip" "backend" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-backend-eip"
  }
}

resource "aws_eip_association" "frontend" {
  instance_id   = aws_instance.frontend.id
  allocation_id = aws_eip.frontend.id
}

resource "aws_eip_association" "backend" {
  instance_id   = aws_instance.backend.id
  allocation_id = aws_eip.backend.id
}
