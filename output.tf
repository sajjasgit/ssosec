output "keypair" {
  value = tls_private_key.this.private_key_pem
}

output "keyname" {
  value = aws_key_pair.generated_key.key_name
}