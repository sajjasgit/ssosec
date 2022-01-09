output "keypair" {
  value = tls_private_key.this.private_key_pem
}

output "keyname" {
  value = local.private_key_pem_name
}