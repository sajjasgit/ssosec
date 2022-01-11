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