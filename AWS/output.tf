# output "keypair" {
#   value = tls_private_key.this.private_key_pem
# }

output "dns_record" {
  value = aws_route53_record.ssosec_r53.name
}