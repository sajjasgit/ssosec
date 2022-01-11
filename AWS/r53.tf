data "aws_route53_zone" "primary" {
  name = var.hostedzone
}

resource "aws_route53_record" "ssosec_r53" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.prefix}.${var.hostedzone}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.ssosec_inc.public_ip]
}