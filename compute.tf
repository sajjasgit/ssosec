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

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.keyname
  public_key = tls_private_key.this.public_key_openssh

  provisioner "local-exec" { # Create ".pem" to your computer!!
    command = "echo '${tls_private_key.this.private_key_pem}' > ${path.module}/${var.keyname}.pem"
  }
}

resource "aws_instance" "ssosec-inc" {
  name                        = local.instance_name
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

  tags = local.tags
}

# resource "aws_volume_attachment" "this" {
#   device_name = "/dev/xvda"
#   volume_id   = aws_ebs_volume.ssosec-ebs.id
#   instance_id = aws_instance.ssosec-inc.id
# }

# resource "aws_ebs_volume" "ssosec-ebs" {
#   availability_zone = local.availability_zone
#   type              = "gp2"
#   size              = 32
# }