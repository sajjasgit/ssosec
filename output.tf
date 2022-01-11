output "keypair" {
  value = tls_private_key.this.private_key_pem
}

output "dns_record" {
  value = module.aws.aws_route53_record.ssosec_r53.name
}