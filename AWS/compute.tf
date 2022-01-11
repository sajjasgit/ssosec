data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

resource "aws_instance" "ssosec-inc" {
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.ssosec-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.ssosec-sg.id]
  associate_public_ip_address = true
  user_data                   = base64encode(templatefile("${path.module}/scripts/install_app.sh", { APP_ECR_REPO_URL = aws_ecr_repository.ssosec-ecr.repository_url, REGION = var.region }))
  key_name                    = aws_key_pair.generated_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.this.name

  root_block_device {
    volume_size = 32
    volume_type = "gp2"
  }

  tags = {
    Name = local.instance_name
  }
}