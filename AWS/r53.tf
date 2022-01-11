data "aws_route53_zone" "primary" {
  name = var.hostedzone
}

resource "aws_route53_record" "ssosec-r53" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.env}.${var.hostedzone}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.ssosec-inc.public_ip]
}